FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbrotli1 libc6 libcom-err2 libcurl4 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 numactl procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb-shell" "1.5.1-0" --checksum 6dcffbfc151ddb35c572f1ec3b6974b99fe7612cb233598786927094a1f0df9d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.26.1-1" --checksum 502f4119e04d7a74508a38d64cccfc332e08fe42335828129d2bf5e694fbec32
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-152" --checksum 0694ae67645c416d9f6875e90c0f7cef379b4ac8030a6a5b8b5cc9ca77c6975d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-151" --checksum 9690a34674f152e55c71a55275265314ed1bb29e0be8a75d7880488509f70deb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb" "5.0.9-3" --checksum 64c6b1723d6808b6be411cabe363de21203e38cf73ed714b270d96f154c80e9b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/liblog.sh /liblog.sh
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/mongodb-sharded/postunpack.sh
ENV APP_VERSION="5.0.9" \
    BITNAMI_APP_NAME="mongodb-sharded" \
    PATH="/opt/bitnami/mongodb/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mongodb-sharded/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mongodb-sharded/run.sh" ]
