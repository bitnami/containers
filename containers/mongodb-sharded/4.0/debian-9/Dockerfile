FROM docker.io/bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpcap0.8 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libtasn1-6 libunistring0 numactl procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.16.1-0" --checksum 525c918f48278b006348d6a8cbd3d06f6aecb2a8d08fa0819e1cbb2b59c8c2e3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-3" --checksum 2ae04ccaef4e6be19af2d3c6df1df30c5a06e17ebcde2079a5af8ffaca339301
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-3" --checksum 27be6253118f80e04fdf2ba0efad2193d63ae8e045b8056f54da1234bd6ca249
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb" "4.0.27-0" --checksum 95b7a05fa4c90f5483f7a93d6b937fdba16ae44b016e5e3b2db6a5b7130462c9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum d177bc3da307f83d83ac8284be8062fc8b428e8f38a3b697876b5efc73ebf74f
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/liblog.sh /liblog.sh
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/mongodb-sharded/postunpack.sh
ENV BITNAMI_APP_NAME="mongodb-sharded" \
    BITNAMI_IMAGE_VERSION="4.0.27-debian-9-r90" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mongodb-sharded/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mongodb-sharded/run.sh" ]
