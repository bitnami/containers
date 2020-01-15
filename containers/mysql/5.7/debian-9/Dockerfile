FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libaio1 libatomic1 libc6 libgcc1 libncurses5 libsasl2-2 libssl1.1 libstdc++6 libtinfo5 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "mysql" "5.7.29-0" --checksum 733d9467ba8db7a7a72410c36d077faaf75e63e1e38e6483a174307ced172df2
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN curl --silent -L https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 > /usr/local/bin/gosu && \
    echo 0b843df6d86e270c5b0f5cbd3c326a04e18f4b7f9b8457fa497b0454c4b138d7 /usr/local/bin/gosu | sha256sum --check && \
    chmod u+x /usr/local/bin/gosu && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/tianon/gosu/master/LICENSE > /opt/bitnami/licenses/gosu-1.11.txt
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mysql" \
    BITNAMI_IMAGE_VERSION="5.7.29-debian-9-r2" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mysql/bin:/opt/bitnami/mysql/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
