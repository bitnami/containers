#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace # Uncomment this line for debugging purpose

TARGET_DIR="."

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
    local -r container_repos="$(jq -r '[ .[] | select(.name | test("bitnami-docker-.")) | select(.archived == false) ]' <<< "$repos")"
    echo "$container_repos" > /tmp/repos
    echo "$container_repos"
}

function pushChanges() {
    git config user.name "Bitnami Containers"
    git config user.email "bitnami-bot@vmware.com"
    git push origin main
}

function mergeRepos() {
    local -r repos="$(getContainerRepos)"
    # Files that should not be moved
    local -r static_files=(. .git containers)
    # Files that will checkout bitnami/containers main branch on every sync
    local -r special_files=(CONTRIBUTING.md CODE_OF_CONDUCT.md LICENSE.md .github scripts)

    mkdir -p "$TARGET_DIR"

    # Build array of app names since we need to exclude them when moving files
    local apps=("mock")
    local -r urls=($(echo "$repos" | jq -r '.[].html_url'))
    for repo_url in "${urls[@]}"; do
        name="${repo_url:42}" # 42 is the length of https://github.com/bitnami/bitnami-docker-
        apps=("${apps[@]}" "$name")
    done
    echo "$repos" | jq -r '.[].html_url' | while read -r repo_url; do
        name="${repo_url:42}" # 42 is the length of https://github.com/bitnami/bitnami-docker-
        (
            cd "$TARGET_DIR"
            mkdir -p "containers/${name}" # Create directory for the app

            # clone the repositoy outside of this one
            git clone "$repo_url" ../temporal/"$name"
            (
                cd ../temporal/"$name"
                mkdir -p containers/"$name"
                git-filter-repo --to-subdirectory-filter containers/"$name" --force
            )
            # Fetch the old repo and merge maintaining history
            git remote add --fetch "$name" "../temporal/${name}"
            git merge "${name}/master" --allow-unrelated-histories --no-log --no-ff -Xtheirs
            git remote remove "$name"
            rm -Rf ../temporal/"$name"
        )
    done

    pushChanges
}

mergeRepos
