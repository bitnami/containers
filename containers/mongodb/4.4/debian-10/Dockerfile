FROM docker.io/bitnami/minideb:buster
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 numactl procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb-shell" "1.5.0-0" --checksum ab840925a52827b7a0ff38d891f4446e1e72d11c2308d15f4d58ae148b414544
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.25.3-1" --checksum 175fd73af8de9f084efda42721c5151832b443754c460c961945df78afc14231
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-0" --checksum 0603c8eaf6d24e76563431e36e512da06bfebb3a06ede31b3e84d9879213c162
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-0" --checksum af5ec81cfb8e8420fe6af80a77d40da25e0f7e136abb6dde27267c97fb27cf8b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb" "4.4.15-1" --checksum 9af424752168d7b98ef0fc0ab62e6d5ead7151ad1f6c8ee367eae93fb93e730f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-8" --checksum ca9fcfe190d596e3974a917cff96488b5a9d69b98edf45b2afd2cf43ebb4f03d
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mongodb/postunpack.sh
ENV APP_VERSION="4.4.15" \
    BITNAMI_APP_NAME="mongodb" \
    PATH="/opt/bitnami/mongodb/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mongodb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mongodb/run.sh" ]
