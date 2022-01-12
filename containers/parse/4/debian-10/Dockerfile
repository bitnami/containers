FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-12" --checksum c081f7f9663d4d64e7f26d6e6a77b3860ee1f39c309bd564f801c39192042d2f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "12.22.8-1" --checksum 19116f1a9196ee578308e1698482949bbdbabb3e8ae38f154c7e36d47faccfee
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb-client" "4.4.11-1" --checksum 16c1ce1398b6ee27665c150a8202df7fac08a52e4e897197c271952e9aea682f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse" "4.10.4-1" --checksum a5ebf7040410f9a208e7fed236fcb31b7e1ce220266904342dcd3df759c42121
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-1" --checksum 16f1a317859b06ae82e816b30f98f28b4707d18fe6cc3881bff535192a7715dc
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse/postunpack.sh
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="4.10.4-debian-10-r88" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/mongodb-client/bin:/opt/bitnami/parse/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 1337 3000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse/run.sh" ]
