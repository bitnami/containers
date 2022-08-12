FROM docker.io/bitnami/minideb:bullseye
ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="4.18.1-debian-11-r29" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/express" \
      org.opencontainers.image.title="express" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="4.18.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbrotli1 libbz2-1.0 libc6 libcom-err2 libcrypt1 libcurl4 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle8 libnghttp2-14 libnsl2 libp11-kit0 libpsl5 libreadline8 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 procps sudo tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-165" --checksum 2bf41f60dccdcf65842d993083c2dcb27ab48a8a514fdeb1778e9b09f3e4a203
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.20.0-2" --checksum 127f7b97bd46468ce62bc5cd9868371ca2c4c1e7201f6271a309b34a17b97d90
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "sequelize-cli" "6.4.1-152" --checksum 73c2fa10e4ec3e725449ec458f66e180989182f8a6d1c4e8268feceee2415dcc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.37.2-0" --checksum e695c1e29ff39cd54da23d2d5c3703d7d767a1d17d42ca85b3581d6e2d171bca
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "express-generator" "4.16.1-152" --checksum c8b7b506b6612b666e65f7177d749f2e812b3e0dac9ced61ae4ca8d1e19cade3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "bower" "1.8.12-152" --checksum a15b478124411ef8997a3e1ce6942b7aa9f0ceb2cd2919db16663d3f17ec4623
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-153" --checksum 8c8e324ab6e7b7d76b4655182d6ea5f6550edfc9e32bec92228e678c26fc8b16
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "express" "4.18.1-152" --checksum d7959c1389f5446666f8a65a2100a066810f786bfc1be9ff4d1f498646e44089
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwX /dist /app /.npm /.config /.cache /.local
RUN /opt/bitnami/scripts/express/postunpack.sh
ENV APP_VERSION="4.18.1" \
    BITNAMI_APP_NAME="express" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/common/bin:/opt/bitnami/sequelize-cli/bin:/opt/bitnami/git/bin:/opt/bitnami/bower/bin:/opt/bitnami/express/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/express/entrypoint.sh" ]
CMD [ "npm", "start" ]
