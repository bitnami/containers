#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace # Uncomment this line for debugging purpose

TARGET_DIR="."

COMMIT_SHIFT="${1:-0}" # Used when you push commits manually
CONTAINER="${2:-}" # USed when we want to sync a single container

function queryRepos() {
    local page=0
    local repos="[]" # Initial empty JSON array
    local -r repos_per_page="100"

    while [[ "$page" -gt -1 ]]; do
        # Query only the public repos since we won't add private containers to bitnami/containers
        page_repos="$(curl -H 'Content-Type: application/json' -H 'Accept: application/json' "https://api.github.com/orgs/bitnami/repos?type=public&per_page=${repos_per_page}&page=${page}")"
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

function getContainerRepos() {
    local -r repos="$(queryRepos)"
    # Get only bitnami-docker-* not archived repos
    local -r container_repos="$(jq -r '[ .[] | select(.name | test("bitnami-docker-.")) | select(.archived == false) ]' <<< "$repos")"
    echo "$container_repos"
}

# Commits a directory
function gitConfigure() { 
    git config user.name "Bitnami Containers"
    git config user.email "containers@bitnami.com"
}

function pushChanges() {
    git config user.name "Bitnami Containers"
    git config user.email "containers@bitnami.com"
    git push origin main
}

function findCommitsToSync() {
    local origin_name="${1:?Missing origin name}"
    # Get all commits IDs on the origin
    local -r commits=($(git rev-list "${origin_name}/master" -- .))
    # Find the commit that doesn't have changes respect the container folder
    # Get the last commit message in the container folder
    local shift=$((COMMIT_SHIFT + 1))
    local -r last_commit_message="$(git log -n "$shift" --pretty=tformat:"%s" -- ./containers/"$origin_name" | tail -n 1)"
    # Search on the container origin repo the ID for the latest commit we have locally in the container folder
    local -r last_synced_commit_id="$(git rev-list "$origin_name"/master --grep="${last_commit_message}")"
    local commits_to_sync=""
    local max=100 # If we need to sync more than 100 commits there must be something wrong since we run the job on a daily basis
    for commit in "${commits[@]}"; do
        if [[ "$commit" != "$last_synced_commit_id" ]] && [[ "$max" -gt "0" ]]; then
            commits_to_sync="${commit} ${commits_to_sync}"
        else
            # We reached the last commit synced
            break
        fi
        max=$((max - 1))
    done
    
    [[ "$max" -eq "0" ]] && echo "Last commit not found into the original repo history" && return 1
    printf "$commits_to_sync"
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
                # If the commit is a merge, it has more than one parent, use the second to avoid re-applying an old commit
                actual_merge_commit_id="$(git log --pretty=%P -n 1 "$commit" | awk '{print $2}')"
                if [[ -n "$actual_merge_commit_id" ]]; then
                  syncCommit "$actual_merge_commit_id" "$name"
                else
                  syncCommit "$commit" "$name"
                fi
            done
        fi
        git remote remove "$name"
    )
}

function syncRepos() {

    gitConfigure # Configure Git client
    mkdir -p "$TARGET_DIR"

    if [[ -z "$CONTAINER" ]]; then
        local -r repos="$(getContainerRepos)"        
       
        # Build array of app names since we need to exclude them when moving files
        local apps=("mock")
        local -r urls=($(echo "$repos" | jq -r '.[].html_url' | sort | uniq))
        for repo_url in "${urls[@]}"; do
            name="${repo_url:42}" # 42 is the length of https://github.com/bitnami/bitnami-docker-
            apps=("${apps[@]}" "$name")
        done
        echo "$repos" | jq -r '.[].html_url' | sort | uniq | while read -r repo_url; do
            name="${repo_url:42}" # 42 is the length of https://github.com/bitnami/bitnami-docker-
            syncContainerCommits "$name"
        done
    else 
        syncContainerCommits "$CONTAINER" 
    fi

    pushChanges
}

syncRepos
