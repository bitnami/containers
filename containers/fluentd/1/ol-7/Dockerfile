FROM bitnami/oraclelinux-extras-base:7-r456
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc jemalloc-devel keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ ncurses-libs nss-softokn-freebl openssl-libs pcre readline wget zlib
RUN . ./libcomponent.sh && component_unpack "ruby" "2.6.5-0" --checksum 29ef6f1ed911c95ada9710d617438ec90e6e822cae31d2b82d578f9b9e7b1c30
RUN . ./libcomponent.sh && component_unpack "fluentd" "1.7.3-0" --checksum 3b0e66da1a66439f85dbf4a4d4c55c39ccb28a8f69b22d45e59b318494c52052

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.7.3-ol-7-r24" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 24224 5140

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
