FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libdb5.3 libltdl7 libnss3-tools libodbc1 libperl5.28 libsasl2-2 libssl1.1 libwrap0 mdbtools procps sudo unzip
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "openldap" "2.4.50-0" --checksum d98bf0a8de65dc9aafde28349cce66cc3f88b18b62d762634e7aa2a1c61db046
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/openldap/postunpack.sh
ENV BITNAMI_APP_NAME="openldap" \
    BITNAMI_IMAGE_VERSION="2.4.50-debian-10-r0" \
    PATH="/opt/bitnami/openldap/bin:/opt/bitnami/common/bin:/opt/bitnami/openldap/sbin:$PATH"

EXPOSE 1389 1636

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/openldap/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/openldap/run.sh" ]
