#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0
#
# Pull a jar file from maven repository and validate its checksum

# shellcheck disable=SC1091,SC2086

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh

# Functions

########################
# Download jar file from maven repository by mvn maven_coordinates. Then validate checksum
# Arguments:
#   $1 - Maven maven_coordinates (group_id:artifact_id:version)
#   $2 - Destination folder
# Returns:
#
#########################
maven_get_jar() {
    local maven_coordinates="${1:?Required argument maven_coordinates missing}"
    local destination_folder="${2:?Required argument destination_folder missing}"
    local group_id
    local artifact_id
    local version

    # Create the output directory if it doesn't exist
    mkdir -p "$destination_folder"

    IFS=':' read -r group_id artifact_id version <<< "$maven_coordinates"

    # Construct the URL for the Maven JAR file
    local mavenJarUrl="https://repo1.maven.org/maven2/$(echo "$group_id" | tr '.' '/')/$artifact_id/$version/$artifact_id-$version.jar"
    local jarFileName="$artifact_id-$version.jar"

    # Download the JAR file and its sha1 file
    debug "Downloading $mavenJarUrl"
    pushd "$destination_folder" >/dev/null || return
    curl -L -s -f -o "$jarFileName" "$mavenJarUrl"
    curl -L -s -f -o "${jarFileName}.sha1" "$mavenJarUrl.sha1"

    # Validate the JAR file using SHA-1
    echo "$(cat ${jarFileName}.sha1) *$jarFileName" | sha1sum -c -
    rm -f "${jarFileName}.sha1"
    popd >/dev/null || return

    info "Fetched maven artifact $maven_coordinates"
}
