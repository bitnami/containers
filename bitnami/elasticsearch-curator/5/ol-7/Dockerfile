FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/elasticsearch-curator/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libffi libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre procps-ng readline sqlite sudo tar wget which xz-libs zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install python-3.6.10-0 --checksum 5a8e49832c587612e6b4afa4dfe4708dc2153263ec594006eb7972c3352773b3
RUN bitnami-pkg install elasticsearch-curator-5.8.1-0 --checksum bd068de882316817e4894557640b68478cfc2de1a480254cc5f873306519db15
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN yum reinstall -y glibc-common && localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="elasticsearch-curator" \
    BITNAMI_IMAGE_VERSION="5.8.1-ol-7-r97" \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    NAMI_PREFIX="/.nami"

USER 1001
ENTRYPOINT [ "curator" ]
CMD [ "--help" ]
