FROM bitnami/oraclelinux-extras:7-r568
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates glibc keyutils-libs krb5-libs libcom_err libffi libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre readline sqlite wget xz-libs zlib
RUN bitnami-pkg install python-3.6.9-3 --checksum d536fd53c119fbd4e3cc34ba5f371c652eb9d78565617b53fb12b2ab5a8f7682
RUN bitnami-pkg install elasticsearch-curator-5.8.1-0 --checksum bd068de882316817e4894557640b68478cfc2de1a480254cc5f873306519db15
RUN yum reinstall -y glibc-common && localedef -c -f UTF-8 -i en_US en_US.UTF-8

COPY rootfs /
ENV BITNAMI_APP_NAME="elasticsearch-curator" \
    BITNAMI_IMAGE_VERSION="5.8.1-ol-7-r54" \
    LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/elasticsearch-curator/bin:$PATH"

USER 1001
ENTRYPOINT [ "curator" ]
CMD [ "--help" ]
