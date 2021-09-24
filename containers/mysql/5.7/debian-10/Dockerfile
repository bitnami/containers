FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libatomic1 libc6 libgcc1 libncurses6 libsasl2-2 libssl1.1 libstdc++6 libtinfo6 procps psmisc tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.0-0" --checksum 88093e848950fd09e80eb26cac55caa11e77aa78f118b5dc67faa38a3836381d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql" "5.7.35-1" --checksum 0f54864831443ae1583c6d4078b52e90b7c4a0410421efcaedb1a4cde5ee990e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mysql/postunpack.sh
ENV BITNAMI_APP_NAME="mysql" \
    BITNAMI_IMAGE_VERSION="5.7.35-debian-10-r64" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mysql/bin:/opt/bitnami/mysql/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mysql/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mysql/run.sh" ]
