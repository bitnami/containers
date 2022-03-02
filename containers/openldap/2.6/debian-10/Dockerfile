FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 libltdl7 liblz4-1 libnss3-tools libodbc1 libperl5.28 libsasl2-2 libsnappy1v5 libssl1.1 libstdc++6 libwiredtiger0 libwrap0 libzstd1 mdbtools procps psmisc tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "openldap" "2.6.1-5" --checksum e9f02838b655c63b779bf19d43a1efce521d6b473014dc173376cbd4b16f9a97
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/openldap/postunpack.sh
ENV BITNAMI_APP_NAME="openldap" \
    BITNAMI_IMAGE_VERSION="2.6.1-debian-10-r39" \
    PATH="/opt/bitnami/openldap/bin:/opt/bitnami/openldap/sbin:/opt/bitnami/common/bin:$PATH"

EXPOSE 1389 1636

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/openldap/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/openldap/run.sh" ]
