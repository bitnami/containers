FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libc6 libcom-err2 libgcc1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libncurses6 libsasl2-2 libssl1.1 libstdc++6 libtinfo6 procps psmisc tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.1-0" --checksum 3d189e4b1fcdc330fb84c14a7c6fb296deff37d3142d9a17fe0c9a5dba51ef6d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql" "8.0.27-0" --checksum ecf32403a164762ed92eb0823aa0a55a70d6c02fb0c19bab0fdfc949fc8d7849
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mysql/postunpack.sh
ENV BITNAMI_APP_NAME="mysql" \
    BITNAMI_IMAGE_VERSION="8.0.27-debian-10-r72" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mysql/bin:/opt/bitnami/mysql/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mysql/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mysql/run.sh" ]
