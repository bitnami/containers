FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 procps sudo tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-12" --checksum c081f7f9663d4d64e7f26d6e6a77b3860ee1f39c309bd564f801c39192042d2f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.18.3-6" --checksum a529a3386f396110186951a0a4a4e1f440440d627041589635f69dbf0bdac116
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "sequelize-cli" "5.5.1-4" --checksum b85f42283986c59b2ffd651f50f8d45152c9f40807b89a9cce889641cca07168
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.0-0" --checksum 51075db42727d7b14b9941e7d7c063a135e9ad60cc606676d6e817e7d4a607b9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "express-generator" "4.16.1-4" --checksum 49a2dcf628436b74e99f0b24e74f9cdca041f96835dce338f5efbb1533d050d6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "bower" "1.8.12-4" --checksum dc5868ac800dd5d6e2b8172c4906f58c2518c20acfb42bece2d6e7ebcd2a93a4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-6" --checksum 845ff207415b5730cadd45aa3c757ca45a5c9e73bc54c24aa481ddca24eec35d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "express" "4.17.2-4" --checksum 5c2b0b0cc56bd43e8aedc959aac2851a65470fe8b1e59e77d0158c37c68d421c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwX /dist /app /.npm /.config /.cache /.local
RUN /opt/bitnami/scripts/express/postunpack.sh
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.2-debian-10-r38" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/sequelize-cli/bin:/opt/bitnami/git/bin:/opt/bitnami/bower/bin:/opt/bitnami/common/bin:/opt/bitnami/express/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/express/entrypoint.sh" ]
CMD [ "npm", "start" ]
