FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-157" --checksum 90a2d048ed71588dfff55262b4522e3ee49418b7ea6e560054bf50988ae1265f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.20.0-1" --checksum 1308eadfadd439cc82f4ca51185828f49cac7b38fcafd783e24f52c7c2768b4b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb-shell" "1.5.2-0" --checksum f74f33283157af00201291fcd327136c00b49b97d67f344f61e52333421dfbbd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse" "4.10.13-1" --checksum f241437c1196bdb0d717bfb90512fd67cd4652be4a88a2fb7047d87bb6284fa8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse/postunpack.sh
ENV APP_VERSION="4.10.13" \
    BITNAMI_APP_NAME="parse" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 1337 3000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse/run.sh" ]
