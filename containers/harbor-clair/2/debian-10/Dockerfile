FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcom-err2 libcurl4 libffi6 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 procps rpm tar xz-utils zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.27.0-1" --checksum 8d31650a86d07490247771e216e064819564452a7e2c2fe69ffbffdb9c079b0a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-1" --checksum 07c4678654b01811f22b5bb65a8d6f8e253abd4524ebb3b78c7d3df042cf23bd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-clair" "2.0.0-0" --checksum 0dbbac7e7fa381623425fae777d24abb633ba5dfbaa8ba5f317692242f949747
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-1" --checksum 51cfb1b7fd7b05b8abd1df0278c698103a9b1a4964bdacd87ca1d5c01631d59c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
ENV BITNAMI_APP_NAME="harbor-clair" \
    BITNAMI_IMAGE_VERSION="2.0.0-debian-10-r25" \
    PATH="/opt/bitnami/git/bin:/opt/bitnami/common/bin:/opt/bitnami/harbor-clair/bin:$PATH"

EXPOSE 6060 6061

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-clair/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-clair/run.sh" ]
