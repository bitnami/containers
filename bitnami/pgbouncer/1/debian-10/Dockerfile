FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaudit1 libbsd0 libc-ares2 libc6 libcap-ng0 libedit2 libevent-2.1-6 libffi6 libgcc1 libgmp10 libgnutls30 libhogweed4 libicu63 libidn2-0 libldap-2.4-2 liblzma5 libnettle6 libp11-kit0 libpam0g libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 locales procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-5" --checksum 1e34030c18f0ec2467fa5f1b1fbad24add217f671c3a61628f7b8671391f9676
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "10.19.0-1" --checksum 53e64e567d4563efaea05f4e9e9eead3a3fbec1213a05528a5eeec2d2f8e8a43
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.1-2" --checksum 8fc4b049c856c022b49dd27ded8d0f3945a01f1fa8d2196f391ce481b8e95e3a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-2" --checksum 7419bc5e2be68eb14c92e321acc843413481cda73323fb8c0d1dda8b1e5aa9d5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "pgbouncer" "1.16.1-2" --checksum dc32df99f89d1ffde4e5fa9cd63c492b916be11a4cd9ea31eede44fb6fae3bb7
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
RUN /opt/bitnami/scripts/pgbouncer/postunpack.sh
ENV BITNAMI_APP_NAME="pgbouncer" \
    BITNAMI_IMAGE_VERSION="1.16.1-debian-10-r68" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NSS_WRAPPER_LIB="/opt/bitnami/common/lib/libnss_wrapper.so" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/pgbouncer/bin:$PATH"

EXPOSE 6432

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/pgbouncer/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/pgbouncer/run.sh" ]
