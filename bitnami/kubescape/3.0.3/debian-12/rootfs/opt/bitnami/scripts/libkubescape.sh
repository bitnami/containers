#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
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

########################
# Prints the usage instructions for the oss_assessment custom action
# Arguments:
#   None
# Returns:
#   None
#########################
kubescape_oss_assessment_usage() {

  echo """
Usage:
  docker run --rm -it bitnami/kubescape:<tag> oss-assessment scan [project] [flags]

Examples:

  Scan command is for scanning an existing cluster or kubernetes manifest files based on pre-defined frameworks

  # Scan git repository
  docker run --rm -it bitnami/kubescape oss-assessment <repository_url>

  # Scan remote Kubernetes cluster.
  docker run --rm -it -v /path/to/.kubeconfig:/.kubeconfig bitnami/kubescape oss-assessment --kubeconfig /.kubeconfig

  # Scan and save the results into a file
  docker run --rm -it -v /path/to/output:/output bitnami/kubescape oss-assessment --output /output/report.json

  # Disable kubescape logs
  docker run --rm -it bitnami/kubescape oss-assessment 'repository_url' --log-level error

  # Enable debug logs
  docker run --rm -it -e BITNAMI_DEBUG=true bitnami/kubescape oss-assessment 'repository_url' --log-level error

  # Disable all logs and export result using docker output
  docker run --rm -it bitnami/kubescape oss-assessment 'repository_url' --silent > report.json

  # NOTE: When using volumes, permission changes may be required because of the container running as user 1001

Flags:
      --kubeconfig string                      Paths to a kubeconfig. Required to scan Kubernetes cluster.
  -h, --help                                   Print help for oss-assessment action
  -o, --output string                          Output file. Print output to file and not stdout
  -l, --log-level string                       Log level for the kubescape scan and kubescape scan image commands.
  -r, --retries                                Number of retries for each 'kubescape scan image' command.
  -s, --silent                                 Do not display any logs in stdout, only the resulting report.

  # NOTE: Additionally, other 'kubescape scan' flags can be added, run 'kubescape scan -h' for additional information.
  """
}

########################
# Runs a kubescape scan and enriches it with Vulnerabilities information for images available in Tanzu Application Catalog
# Arguments:
#   - project_url (optional)
#   - Supported kubescape flags
# Returns:
#   None
#########################
kubescape_oss_assessment() {

  local cmd="kubescape"
  local scan_args=("scan" "--format=json")
  local scan_image_args=("scan" "image" "--format=json")
  local silent="false"
  local output=""
  local retries="3"

  # By default, Kubescape only runs NSA and MITRE frameworks
  # We want to extend that to also include SOC2 and CIS frameworks
  readarray -t frameworks < <(${cmd} list frameworks --format=json | jq '.[]' | grep -Ei "nsa|mitre|soc2|cis-v" | sed 's/"//g')
  if [[ "${#frameworks[@]}" -gt 0 ]]; then
    info  "OSS Assessment scan will use the following frameworks: ${frameworks[*]}"
    scan_args+=("framework" "$(tr ' ' ',' <<< "${frameworks[*]}")")
  else
    warn "Could not obtain frameworks, using default ones."
  fi

  # Handle input
  while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
      oss-assessment)
          shift
          ;;
      -h|--help)
          kubescape_oss_assessment_usage
          exit 0
          ;;
      -o|--output)
          output="$2"
          shift 2
          ;;
      -s|--silent)
          silent="true"
          shift
          ;;
      -r|--retries)
          retries="$2"
          shift 2
          ;;
      *)
          scan_args+=("$1")
          shift
          ;;
    esac
  done

  # Check that Tanzu Application Catalog file exists
  if [[ -f "${TANZU_APPLICATION_CATALOG_FILE}" ]]; then
    TAC_PRODUCTS=$(jq -r '.[].product.key' "$TANZU_APPLICATION_CATALOG_FILE")
  else
    error "The Bitnami Catalog JSON file is missing: ${TANZU_APPLICATION_CATALOG_FILE}"
  fi

  # Run Kubescape scan for the provided project and add custom field 'security'
  info "Running command '${cmd} ${scan_args[*]}'"
  if is_boolean_yes "$silent"; then
    KUBESCAPE_OUTPUT="$(${cmd} "${scan_args[@]}" 2> /dev/null | jq '.security = []' || true)"
  else
    KUBESCAPE_OUTPUT="$(${cmd} "${scan_args[@]}" | jq '.security = []' || true)"
  fi
  if [[ -n "$KUBESCAPE_OUTPUT" ]]; then
    ! is_boolean_yes "$silent" && debug "Result:\n$KUBESCAPE_OUTPUT"
  else
    error "Failed to execute command 'kubescape scan'."
    exit 1
  fi

  # Search for images available in Tanzu Application Catalog
  ! is_boolean_yes "$silent" && info "Searching images available in Tanzu Application Catalog"
  local -a matching_images
  readarray -t project_images < <(echo "$KUBESCAPE_OUTPUT" | jq -r '.resources[]?.object?.spec?.template?.spec?.containers[]?.image')

  for image in "${project_images[@]}"; do
    ! is_boolean_yes "$silent" && info "Found image: $image"
    for tac_image in $TAC_PRODUCTS; do
      if [[ $image =~ $tac_image ]]; then
        ! is_boolean_yes "$silent" && info "Found Tanzu Application Catalog image matching! Adding image '${image}' to the scanning list"
        matching_images+=("$image")
        break
      fi
    done
  done

  # Filter out duplicated images
  read -r -a unique_matching_images <<< "$(echo "${matching_images[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')"
  ! is_boolean_yes "$silent" && info "Scanning images ${unique_matching_images[*]}"
  images_scanned=0
  images_success_scanned=0

  # For each image available in Tanzu Application Catalog, add a vulnerability report to the original project scan
  for image in "${unique_matching_images[@]}"; do
    KUBESCAPE_IMAGE_OUTPUT=""
    info "Scanning image $((images_scanned + 1)) out of ${#unique_matching_images[@]}: ${image}"
    for ((i = 1; i <= retries; i += 1)); do
      KUBESCAPE_IMAGE_OUTPUT="$(${cmd} "${scan_image_args[@]}" "${image}" 2> /dev/null || echo '')"
      if [[ -n "$KUBESCAPE_IMAGE_OUTPUT" ]]; then
        debug "Result: $KUBESCAPE_IMAGE_OUTPUT"
        break
      else
        ! is_boolean_yes "$silent" && debug "Image scan failed. Retrying... ${i}/${retries}"
      fi
    done

    if [[ -n "$KUBESCAPE_IMAGE_OUTPUT" ]]; then
      KUBESCAPE_IMAGE_VULNS="$(jq --arg image "$image" '{imageID: $image, vulnerabilities: [.matches[].vulnerability | {id, severity, urls}]}' <(echo "$KUBESCAPE_IMAGE_OUTPUT"))"
      KUBESCAPE_OUTPUT="$(jq '.security += [input]' <(echo "$KUBESCAPE_OUTPUT") <(echo "$KUBESCAPE_IMAGE_VULNS"))"
      images_success_scanned="$((images_success_scanned + 1))"
    else
      debug "Failed to scan image '${image}' after several attempts."
    fi
    images_scanned="$((images_scanned + 1))"
  done

  info "Total scanned: ${images_success_scanned} out of ${#unique_matching_images[@]}"

  ! is_boolean_yes "$silent" && info "OSS Assessment report successfully generated"
  if [[ -n "$output" ]]; then
    echo "$KUBESCAPE_OUTPUT" > "$output"
  else
    echo "$KUBESCAPE_OUTPUT"
  fi

  if [[ "${images_success_scanned}" != "${#unique_matching_images[@]}" ]]; then
    info "For getting a more complete report, visit the OSS Health Assessment FAQ to scan images from private repositories."
  fi
}
