FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpcap0.8 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "3.4.0-1" --checksum a8889ed389089d58955bd5b30d562d612ea540d5bbe5338bc4e68a9e1665c38f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-3" --checksum 7521d9a4f9e4e182bf32977e234026caa7b03759799868335bccb1edd8f8fd12
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.0-2" --checksum f1bee333423f6627d795ea9e0b6a89c18d2e5c2e2d015bb4620f040f1d520cf6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb" "4.2.10-0" --checksum d1e4c831c9b1c8cccedb51c1d4e8184c01895af337cfdb45b65460839f65128b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/liblog.sh /liblog.sh
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/mongodb-sharded/postunpack.sh
ENV BITNAMI_APP_NAME="mongodb-sharded" \
    BITNAMI_IMAGE_VERSION="4.2.10-debian-10-r2" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mongodb-sharded/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mongodb-sharded/run.sh" ]
