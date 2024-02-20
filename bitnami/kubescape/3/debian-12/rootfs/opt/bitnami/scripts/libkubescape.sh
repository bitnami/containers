#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Laravel library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libvalidations.sh

# Load Kubescape environment variables
. /opt/bitnami/scripts/kubescape-env.sh

kubescape_oss_assessment() {
  local project="${2:?missing project argument}"

  if [[ -f "${TANZU_APPLICATION_CATALOG_FILE}" ]]; then
    TAC_PRODUCTS=$(jq -r '.[].product.key' "$TANZU_APPLICATION_CATALOG_FILE")
  else
    error "The Bitnami Catalog JSON file is missing: ${TANZU_APPLICATION_CATALOG_FILE}"
  fi

  # By default, all logging outputs are omitted so the command only prints the command result.
  # TODO: Add options -o/--output and -l/--logger, so users can either configure a output file and/or custom log level

  debug "Running kubescape scan"
  # Run Kubescape scan for the provided project and add custom field 'security'
  KUBESCAPE_OUTPUT="$(kubescape scan "$project" --format=json 2> /dev/null | jq '.security = []')"

  debug "Searching images available in Tanzu Application Catalog"

  local -a matching_images
  readarray -t project_images < <(echo "$KUBESCAPE_OUTPUT" | jq -r '.resources[]?.object?.spec?.template?.spec?.containers[]?.image')

  for image in "${project_images[@]}"; do
    debug "Found image: $image"
    # Search for applications available in the Tanzu Application Catalog
    for tac_image in $TAC_PRODUCTS; do
      # If application is available in TAC, run vulnerability scan for the image and append its result to the Kubescape output
      if [[ $image =~ $tac_image ]]; then
        debug "Found Tanzu Application Catalog image matching! Adding image '${image}' to the scanning list"
        matching_images+=("$image")
        break
      fi
    done
  done

  # Filter out duplicated images
  read -r -a unique_matching_images <<< "$(echo "${matching_images[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')"

  # For each image available in TAC, add a vulnerability report to the original project scan
  for image in "${unique_matching_images[@]}"; do
    local registry
    local tag
    local repository
    local skip="no"

    debug "Running 'kubescape scan image ${image}'"

    registry="$(echo "$image" | grep '/' | cut -d/ -f1 | grep '\.' || true)"
    tag="$(echo "$image" | grep ':' | cut -d: -f2 || echo "latest")"
    repository="$(echo "$image" | cut -d: -f1 | sed "s|^$registry/||")"

    # Skip images that require authentication
    if [[ -n "$registry" ]]; then
      # Skip older quay.io images
      # Ref. https://github.com/kubescape/kubescape/issues/1605
      if [[ "$registry" == "quay.io" ]]; then
        # Older images can be detected by the presence of 'signatures' key in the manifest
        if [[ "$(curl -sL "https://${registry}/v2/${repository}/manifests/${tag}" | jq '.signatures')" != "null" ]]; then
          debug "Skipping image '${image}'. Reason: Old quai.io image. Ref: https://github.com/kubescape/kubescape/issues/1605"
          skip="yes"
        fi
      fi

      # Skip if registry requires authentication
      HTTP_CODE="$(curl -sL -o /dev/null --write-out "%{http_code}" "https://${registry}")"
      if [[ ${HTTP_CODE} -lt 200 || ${HTTP_CODE} -gt 299 ]]; then
        debug "Skipping image '${image}'. Reason: Failed to connect to 'https://${registry}' (code ${HTTP_CODE})"
        skip="yes"
      fi
    fi
    if ! is_boolean_yes "$skip"; then
      KUBESCAPE_IMAGE_VULNS="$(kubescape scan image "$image" --format=json --logger error | jq --arg image "$image" '{imageID: $image, vulnerabilities: [.matches[].vulnerability | {id, severity}]}')"
      KUBESCAPE_OUTPUT="$(jq '.security += [input]' <(echo "$KUBESCAPE_OUTPUT") <(echo "$KUBESCAPE_IMAGE_VULNS"))"
    fi
  done

  debug "OSS Assessment report successfully generated"
  echo "$KUBESCAPE_OUTPUT"
}
