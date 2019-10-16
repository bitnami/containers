FROM bitnami/minideb-extras-base:stretch-r376
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ldap-utils libaudit1 libbsd0 libc6 libcap-ng0 libedit2 libgcc1 libicu57 liblzma5 libncurses5 libnss-ldapd libpam-ldap libpam0g libssl1.1 libstdc++6 libtinfo5 libuuid1 libxml2 libxslt1.1 nslcd zlib1g
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.10.0-1" --checksum 77f89198ede517c8355f466642643cc787989b16bd136c0efcfea0a2d21282cb
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.0.6-1" --checksum 57b281979f058f56f0db85e1e39617531d21816b9dc7a406f2da9fa27cb1c46e

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.0.6-debian-9-r46" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
