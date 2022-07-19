#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose

TARGET_DIR="."

########################
# Query github api to get containers repositories
# Arguments:
#   None
# Returns:
#   None
#########################
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

########################
# Get non archived bitnami containers repositories
# Arguments:
#   None
# Returns:
#   None
#########################
getContainerRepos() {
    local -r repos="$(queryRepos)"
    local -r container_repos="$(jq -r '[ .[] | select(.name | test("bitnami-docker-.")) | select(.archived == false) ]' <<< "$repos")"
    local result=""
    while read -r repo_url; do
        result="${result} ${repo_url:42}"
    done < <(echo "$container_repos" | jq -r '.[].html_url' | uniq | sort)
    echo "$result"
}

########################
# Set git user
# Arguments:
#   None
# Returns:
#   None
#########################
gitConfigure() {
    git config --global user.name "Bitnami Containers"
    git config --global user.email "bitnami-bot@vmware.com"
}

########################
# Push changes to right branch.
# Arguments:
#   None
# Returns:
#   None
#########################
pushChanges() {
    git push origin "$(git rev-parse --abbrev-ref HEAD)"
}

########################
# Sync deprecations.
# Arguments:
#   None
# Returns:
#   None
#########################
syncDeprecations() {
    gitConfigure # Configure Git client
    mkdir -p "$TARGET_DIR"
    local -r repos="$(getContainerRepos)"

    cd  "${TARGET_DIR}/bitnami" || exit
    for container in *; do
        if [[ ! $repos =~ (^|[[:space:]])$container($|[[:space:]]) ]]; then
             # Clean deprecated assets
            echo "Removing container: ${container}"
            rm -rf "${container}"
            git add "${container}"
            git commit -q -m "Remove deprecated container ${container}"
        else
            # Clean deprecated branches
            git clone --depth 1 "https://github.com/bitnami/bitnami-docker-${container}" "/tmp/${container}"
            cd "${container}" || exit
            for branch in *; do
                if [[ -d "${branch}" ]] && [[ ! -d "/tmp/${container}/${branch}" ]]; then
                    # Branch exists in bitnami/containers but it doesn't in bitnami-docker repo
                    rm -rf "${branch}"
                    git add "${branch}"
                    git commit -q -m "Remove deprecated branch ${container}/${branch}"
                fi
            done
            cd - || exit
        fi
    done

    pushChanges
}

syncDeprecations