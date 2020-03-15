FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl ldap-utils libaudit1 libbsd0 libc6 libcap-ng0 libedit2 libffi6 libgcc1 libgmp10 libgnutls30 libhogweed4 libicu63 libidn2-0 libldap-2.4-2 liblzma5 libnettle6 libnss-ldapd libp11-kit0 libpam-ldapd libpam0g libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 nslcd procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "wait-for-port" "1.0.0-1" --checksum 07c4678654b01811f22b5bb65a8d6f8e253abd4524ebb3b78c7d3df042cf23bd
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.12.0-1" --checksum 987971cbe05104f59132ad308e25019dc6a34cda9139e0d515e2f71de1508bd5
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.1.1-0" --checksum 394b0359dd6d3a37236f868657608c0f7281daecda7eb5f8838256101a3c7700
RUN . ./libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.1.1-debian-10-r24" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
