FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages audit-libs ca-certificates curl cyrus-sasl-lib glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcap-ng libcom_err libedit libgcc libicu libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nspr nss nss-pam-ldapd nss-softokn-freebl nss-util openldap openldap-clients openssl-libs pam pcre procps-ng sudo tar unzip which xz-libs zlib
RUN . ./libcomponent.sh && component_unpack "postgresql-client" "10.11.0-0" --checksum 7698c1aeb96133009652bfe6b05713c2450effcdc53f094194d06fe15a04f580
RUN . ./libcomponent.sh && component_unpack "pgpool" "4.1.0-1" --checksum 6a475ce61d6b53a09fa86a43a1eb241948618c59be49e6bcefd4593b93444b2f
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN curl --silent -L https://github.com/bitnami/wait-for-port/releases/download/v1.0/wait-for-port.zip > /tmp/wait-for-port.zip && \
    echo "8d26181f4629211b70db4f96236616056b1ed8e5920d8023f7c883071e76c1ed /tmp/wait-for-port.zip" | sha256sum --check && \
    unzip -q -d /usr/local/bin -o /tmp/wait-for-port.zip wait-for-port && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/bitnami/wait-for-port/master/COPYING > /opt/bitnami/licenses/wait-for-port-1.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="pgpool" \
    BITNAMI_IMAGE_VERSION="4.1.0-ol-7-r93" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/pgpool/bin:$PATH"

EXPOSE 5432

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
