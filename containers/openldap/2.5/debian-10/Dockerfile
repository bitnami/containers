FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 libltdl7 liblz4-1 libnss3-tools libsasl2-2 libsnappy1v5 libssl1.1 libstdc++6 libwiredtiger0 libwrap0 libzstd1 lsof mdbtools procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "openldap" "2.5.5-1" --checksum a8a8d6ee1a872f5a74947493e21821bbc974e992c45ac05902bb97068d19e8cf
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/openldap/postunpack.sh
ENV BITNAMI_APP_NAME="openldap" \
    BITNAMI_IMAGE_VERSION="2.5.5-debian-10-r10" \
    PATH="/opt/bitnami/openldap/bin:/opt/bitnami/openldap/sbin:/opt/bitnami/common/bin:$PATH"

EXPOSE 1389 1636

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/openldap/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/openldap/run.sh" ]
