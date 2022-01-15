FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 libltdl7 liblz4-1 libnss3-tools libodbc1 libperl5.28 libsasl2-2 libsnappy1v5 libssl1.1 libstdc++6 libwiredtiger0 libwrap0 libzstd1 mdbtools procps psmisc tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "openldap" "2.6.0-2" --checksum 3495a0f41fe6ea40aaf1545da0d9a58c9a8a4d53dfa9a3e899dbe878e98058ea
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-1" --checksum 16f1a317859b06ae82e816b30f98f28b4707d18fe6cc3881bff535192a7715dc
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/openldap/postunpack.sh
ENV BITNAMI_APP_NAME="openldap" \
    BITNAMI_IMAGE_VERSION="2.6.0-debian-10-r10" \
    PATH="/opt/bitnami/openldap/bin:/opt/bitnami/openldap/sbin:/opt/bitnami/common/bin:$PATH"

EXPOSE 1389 1636

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/openldap/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/openldap/run.sh" ]
