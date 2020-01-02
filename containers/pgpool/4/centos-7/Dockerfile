FROM bitnami/centos-extras-base:7-r256
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="centos-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages audit-libs cyrus-sasl-lib glibc keyutils-libs krb5-libs libcap-ng libcom_err libedit libgcc libicu libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nspr nss nss-pam-ldapd nss-softokn-freebl nss-util openldap openldap-clients openssl-libs pam pcre xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.11.0-0" --checksum 671f60483a00cfe3314a558c45134fafab7821c5f1bd04d9d33710c4e66848fc
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.1.0-1" --checksum 4dbccf63199001b0b05575867e1b2901cf39fa39ab0f3fb648130c3ab9ac536a

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.1.0-centos-7-r70" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
