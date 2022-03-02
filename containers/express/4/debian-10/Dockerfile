FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 procps sudo tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-37" --checksum 3272da2099afdae735a7d3fb199e83f3bd74b44ebf6953e2f9a3dd0ad45091d1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.0-4" --checksum 0649af9ad2856d01d574146b62c840d3a330f2e85227a2ae73ec6500737ccccc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "sequelize-cli" "5.5.1-8" --checksum 01d999017f6852a67b58aafe191e7c60decac22e2fcef6252a5d3d4964839d02
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.1-5" --checksum da12ba7cebb03c4eb983ba2248daf0ed5399be1bd8fa9d2d3931614ce6079ff6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "express-generator" "4.16.1-8" --checksum 27539ad157fbe90d36b91ef6760d225919ff5e929b4e698e6b051a2c77e1e46e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "bower" "1.8.12-8" --checksum d7bd0d251bb6f7a1ce771bd953c53e4ba7d0bb22ab4f29f92b3e0ba0cbe644bf
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-10" --checksum 35c818ba3f4b5aae905959bc7d3a5e81fc63786e3c662b604612c0aa7fcda8fd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "express" "4.17.3-2" --checksum 399947e2f0edbfc2b40bd401e18f3a59e087e8d1d57c92faa1370e418afbef67
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN mkdir -p /dist /app /.npm /.config /.cache /.local && chmod g+rwX /dist /app /.npm /.config /.cache /.local
RUN /opt/bitnami/scripts/express/postunpack.sh
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.17.3-debian-10-r13" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/sequelize-cli/bin:/opt/bitnami/git/bin:/opt/bitnami/bower/bin:/opt/bitnami/common/bin:/opt/bitnami/express/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/express/entrypoint.sh" ]
CMD [ "npm", "start" ]
