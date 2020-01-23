FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl ldap-utils libaudit1 libbsd0 libc6 libcap-ng0 libedit2 libffi6 libgcc1 libgmp10 libgnutls30 libhogweed4 libicu57 libidn11 libldap-2.4-2 liblzma5 libncurses5 libnettle6 libnss-ldapd libp11-kit0 libpam-ldap libpam0g libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libuuid1 libxml2 libxslt1.1 nslcd procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.11.0-0" --checksum 134b5a1d358c7684f9f89e3b5ec6d1bd1e814e23e335af88930295e7dd2d2587
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.1.0-1" --checksum 35a0599d5f3d1372af31a6eec043ca98c522956251c449497f1f36fc9e9854c6
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN curl --silent -L https://github.com/bitnami/wait-for-port/releases/download/v1.0/wait-for-port.zip > /tmp/wait-for-port.zip && \
    echo "8d26181f4629211b70db4f96236616056b1ed8e5920d8023f7c883071e76c1ed /tmp/wait-for-port.zip" | sha256sum --check && \
    unzip -q -d /usr/local/bin -o /tmp/wait-for-port.zip wait-for-port && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/bitnami/wait-for-port/master/COPYING > /opt/bitnami/licenses/wait-for-port-1.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.1.0-debian-9-r67" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
