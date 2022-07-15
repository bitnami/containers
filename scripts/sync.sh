#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose

TARGET_DIR="."

COMMIT_SHIFT="${1:-0}" # Used when you push commits manually
CONTAINER="${2:-}" # Used when we want to sync a single container
SKIP_COMMIT_ID="${3:-}" # Used in some cases when a patch does not apply because it was applied as part of a PR
SPECIAL_FILES=("CONTRIBUTING.md" "CODE_OF_CONDUCT.md" "LICENSE.md" ".github") # Files to remove in new repos

queryRepos() {
    local page=0
    local repos="[]" # Initial empty JSON array
    local -r repos_per_page="100"

    while [[ "$page" -gt -1 ]]; do
        # Query only the public repos since we won't add private containers to bitnami/containers
        page_repos="$(curl -sH 'Content-Type: application/json' -H 'Accept: application/json' "https://api.github.com/orgs/bitnami/repos?type=public&per_page=${repos_per_page}&page=${page}")"
        repos="$(jq -s 'reduce .[] as $x ([]; . + $x)' <(echo "$repos") <(echo "$page_repos"))"
        n_repos="$(jq length <<< "$page_repos")"
        if [[ "$n_repos" -lt "$repos_per_page" ]]; then
          page="-1"
        else
          page="$((page + 1))"
        fi
    done

    echo "$repos"
}

getContainerRepos() {
    local -r repos="$(queryRepos)"
    local -r container_repos="$(jq -r '[ .[] | select(.name | test("bitnami-docker-.")) | select(.archived == false) ]' <<< "$repos")"
    local result=""
    while read -r repo_url; do
        result="${result} ${repo_url:42}"
    done < <(echo "$container_repos" | jq -r '.[].html_url' | uniq | sort)
    echo "$result"
}

# Commits a directory
gitConfigure() {
    git config --global user.name "Bitnami Containers"
    git config --global user.email "bitnami-bot@vmware.com"
}

pushChanges() {
    git push origin "$(git rev-parse --abbrev-ref HEAD)"
}

findCommitsToSync() {
    local origin_name="${1:?Missing origin name}"
    # Find the commit that doesn't have changes respect the container folder
    # Get the last commit message in the container folder
    local shift=$((COMMIT_SHIFT + 1))
    # Use author date also to distinguish several commits with the same subject.
    local -r last_commit_date_message="$(git log -n "$shift" --pretty=tformat:"%ad----%s" -- ./containers/"$origin_name" | tail -n 1)"
    local -r last_commit_date="${last_commit_date_message%----*}"
    local -r last_commit_message="${last_commit_date_message#*----}"
    # Search on the container origin repo the ID for the latest commit we have locally in the container folder
    local -r last_synced_commit_id="$(git rev-list "$origin_name"/master --since="${last_commit_date}" --grep="${last_commit_message}" --no-merges --date-order --reverse | head -1)"
    local commits_to_sync=""
    local max=100 # If we need to sync more than 100 commits there must be something wrong since we run the job on a daily basis
    # Get all commits IDs on the origin
    local commits=()
    # Get the revision list in topological order ignoring merge commits
    while IFS='' read -r line; do commits+=("$line"); done < <(git rev-list --topo-order --no-merges "${origin_name}/master" -- .)
    for commit in "${commits[@]}"; do
        if [[ "$commit" != "$last_synced_commit_id" ]] && [[ "$max" -gt "0" ]]; then
            if [[ "$commit" != "$SKIP_COMMIT_ID" ]]; then
              commits_to_sync="${commit} ${commits_to_sync}"
            fi
        else
            # We reached the last commit synced
            break
        fi
        max=$((max - 1))
    done

    [[ "$max" -eq "0" ]] && echo "Last commit not found into the original repo history" && return 1
    echo "$commits_to_sync"
}

syncCommit() {
    local -r commit_id="${1:?Missing commit id}"
    local -r app="${2:?Missing app name}"
    local -r patch_file="$(git format-patch -1 "$commit_id")"
    # Apply patch
    git am --directory "containers/${app}" "$patch_file"
    rm  -f "$patch_file"
}

syncContainerCommits() {
    local -r name="${1:?Missing container name}"
    local -r repo_url="https://github.com/bitnami/bitnami-docker-${name}"
    (
        cd "$TARGET_DIR"
        # Fetch the old repo master
        git remote add --fetch "$name" "$repo_url"
        read -r -a commits_to_sync <<< "$(findCommitsToSync "$name")"
        if [[ "${#commits_to_sync[@]}" -eq "0" ]]; then
            echo "Nothing to sync for ${name}"
        else
            for commit in "${commits_to_sync[@]}"; do
                syncCommit "$commit" "$name"
            done
        fi
        git remote remove "$name"
    )
}

syncNewContainer() {
    local -r container="${1:?Missing container name}"
    mkdir -p "${TARGET_DIR}/containers/${container}" # Create directory for the app
    # clone the repositoy outside of this one
    git clone "https://github.com/bitnami/bitnami-docker-${container}" "/tmp/${container}"
    cd "/tmp/${container}" || exit
    # Remove special files
    rm -rf "${SPECIAL_FILES[@]}" || true
    cd - || exit
    # Rewrite history to remove special files.
    for file in "${SPECIAL_FILES[@]}"; do
        git filter-repo --quiet --source "/tmp/${container}" --target "/tmp/${container}" --invert-paths --force --path "${file}"
    done
    # Rewrite history to point files to containers/${container}
    git-filter-repo --quiet --source "/tmp/${container}" --target "/tmp/${container}" --to-subdirectory-filter "containers/${container}" --force

    # Fetch the old repo and merge maintaining history
    git remote add --fetch "$container" "/tmp/${container}"
    git merge "${container}/master" --allow-unrelated-histories --no-log --no-ff -Xtheirs -qm "Merge bitnami-docker-${container} into bitnami/containers"
    git remote remove "$container"
    rm -Rf  "/tmp/${container}"
}

syncRepos() {
    gitConfigure # Configure Git client
    mkdir -p "$TARGET_DIR"

    if [[ -z "$CONTAINER" ]]; then
        local -r repos="$(getContainerRepos)"
        # Sync changes
        for container in $repos; do
            if [[ -d  "${TARGET_DIR}/containers/${container}" ]]; then
                echo "Syncing container: ${container}"
                syncContainerCommits "$container"
            else
                echo "Add new container: ${container}"
                syncNewContainer "$container"
            fi
        done
        # Clean deprecated
        cd  "${TARGET_DIR}/containers" || exit
        for container in *; do
            if [[ ! $repos =~ (^|[[:space:]])$container($|[[:space:]]) ]]; then
                echo "Removing container: ${container}"
                rm -rf "${container}"
                git add "${container}"
                git commit -q -m "Remove deprecated container ${container}"
            fi
        done
    else
        syncContainerCommits "$CONTAINER"
    fi

    pushChanges
}

syncRepos