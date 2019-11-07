FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ldap-utils libaudit1 libbsd0 libc6 libcap-ng0 libedit2 libgcc1 libicu57 liblzma5 libncurses5 libnss-ldapd libpam-ldap libpam0g libssl1.1 libstdc++6 libtinfo5 libuuid1 libxml2 libxslt1.1 nslcd zlib1g
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.10.0-1" --checksum 77f89198ede517c8355f466642643cc787989b16bd136c0efcfea0a2d21282cb
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.1.0-0" --checksum 65c73b3ecddcf67c95da911a6123ed4e5f043a35f46b66bb9ea441914bae6ed7

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.1.0-debian-9-r5" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
