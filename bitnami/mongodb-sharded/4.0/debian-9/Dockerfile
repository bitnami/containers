FROM docker.io/bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpcap0.8 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libtasn1-6 libunistring0 numactl procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.15.1-0" --checksum e27aa49c5e121d73615369cfc89842bbdaabb8acce9edd90152187efbf36df89
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-1" --checksum 6d7dbad2c79295df1e52aafb25c50e99c70b6fb8c39e0c732994a78d9403e262
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-1" --checksum 0b6456636342f9f531c7573ef7d93e3ae668398d172d21c42b5fd41d785c1ff3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb" "4.0.27-0" --checksum 95b7a05fa4c90f5483f7a93d6b937fdba16ae44b016e5e3b2db6a5b7130462c9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum d177bc3da307f83d83ac8284be8062fc8b428e8f38a3b697876b5efc73ebf74f
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/liblog.sh /liblog.sh
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/mongodb-sharded/postunpack.sh
ENV BITNAMI_APP_NAME="mongodb-sharded" \
    BITNAMI_IMAGE_VERSION="4.0.27-debian-9-r76" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mongodb-sharded/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mongodb-sharded/run.sh" ]
