#!/bin/bash

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 package1 package2 ... packageN"
    exit
fi

OS_ARCH="${TARGETARCH:-amd64}"
trivy_install_base_dir="/tmp/trivy"
trivy_bin="${trivy_install_base_dir}/bin/trivy"

if [[ ! -f "${trivy_bin}" ]]; then
    TRIVY_VERSION="0.60.0-0"
    TRIVY_PKG="trivy-${TRIVY_VERSION}-linux-${OS_ARCH}-debian-12"

    mkdir -p "${trivy_install_base_dir}"/pkg/cache
    cd "${trivy_install_base_dir}"/pkg/cache || exit 1
    curl -SsLf "https://${DOWNLOADS_URL}/${TRIVY_PKG}.tar.gz" -O
    curl -SsLf "https://${DOWNLOADS_URL}/${TRIVY_PKG}.tar.gz.sha256" -O

    sha256sum -c "${TRIVY_PKG}.tar.gz.sha256"

    tar -zxf "${TRIVY_PKG}.tar.gz" -C "${trivy_install_base_dir}" --strip-components=3 --no-same-owner --wildcards '*/files'

    cd - || exit 1
fi

package_names=$(printf "%s\n" "$@" | jq -R -s -c 'split("\n") | map(select(length > 0))')
"${trivy_bin}" rootfs --format spdx-json / > spdx.json

spdx=$(jq --argjson packages "$package_names" '
    .packages |= map(select(.primaryPackagePurpose == "OPERATING-SYSTEM" or (.name as $name | $packages | index($name))))
    | del(.packages[].annotations)
    | .relationships |= map(select(.relationshipType == "CONTAINS"))
' spdx.json)

licenseRefs=$(echo "$spdx" | jq '[.packages[] | select(.licenseConcluded != null) | .licenseConcluded | scan("LicenseRef-[a-zA-Z0-9]+")]')

ids=$(echo "$spdx" | jq '[.packages[].SPDXID]')
mkdir -p "/opt/bitnami/os"

echo "$spdx" | jq --argjson ids "$ids" '
       .relationships = ($ids | map(
           if startswith("SPDXRef-OperatingSystem") then
               { "spdxElementId": "SPDXRef-DOCUMENT",  "relatedSpdxElement": ., "relationshipType": "DESCRIBES" }
           else
               { "spdxElementId": $ids | map(select(startswith("SPDXRef-OperatingSystem")))[0], "relatedSpdxElement": ., "relationshipType": "CONTAINS" }
           end
       ))
   ' | jq --argjson licenseRefs "$licenseRefs" '
       .hasExtractedLicensingInfos |= map(select(.licenseId as $id | $licenseRefs | index($id) != null))
   ' > "/opt/bitnami/os/.spdx-os.spdx"

rm -rf "${trivy_install_base_dir}"
