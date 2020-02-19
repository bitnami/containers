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
RUN . ./libcomponent.sh && component_unpack "fluentd" "1.9.2-0" --checksum a28e23afa44522a4738d380caeae17558765eb4ab3bdd81aa247c18a8b62bad0
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.9.2-ol-7-r6" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 24224 5140

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
