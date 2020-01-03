FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname jemalloc-devel keyutils-libs krb5-libs libaio-devel libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre procps-ng readline sudo tar wget which zlib
RUN . ./libcomponent.sh && component_unpack "ruby" "2.6.5-0" --checksum 29ef6f1ed911c95ada9710d617438ec90e6e822cae31d2b82d578f9b9e7b1c30
RUN . ./libcomponent.sh && component_unpack "fluentd" "1.8.1-0" --checksum cde1ae7178b9e05c2ca029dab0a7a3c90be49271555326f52191d4681fe13dc9
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN curl --silent -L https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 > /usr/local/bin/gosu && \
    echo 0b843df6d86e270c5b0f5cbd3c326a04e18f4b7f9b8457fa497b0454c4b138d7 /usr/local/bin/gosu | sha256sum --check && \
    chmod u+x /usr/local/bin/gosu && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/tianon/gosu/master/LICENSE > /opt/bitnami/licenses/gosu-1.11.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.8.1-ol-7-r8" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 24224 5140

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
