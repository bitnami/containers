FROM bitnami/minideb-extras-base:stretch-r362
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ldap-utils libaudit1 libbsd0 libc6 libcap-ng0 libedit2 libgcc1 libicu57 liblzma5 libncurses5 libnss-ldapd libpam-ldap libpam0g libssl1.1 libstdc++6 libtinfo5 libuuid1 libxml2 libxslt1.1 nslcd zlib1g
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.10.0-0" --checksum 1f7e0f81461e8ab2593f88f79a2eb618ee657647fcc971b4c150a7fd9c40433a
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.0.6-0" --checksum d34a29982d08302f13c6c3531e2cf4e01c5042d1126fd3347b573c695552e140

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.0.6-debian-9-r13" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
