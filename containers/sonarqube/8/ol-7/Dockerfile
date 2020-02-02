FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/java/bin:/opt/bitnami/sonarqube/bin/linux-x86-64/:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl cyrus-sasl-lib glib2 glibc gzip hostname keyutils-libs krb5-libs libaio-devel libblkid libcom_err libedit libffi libgcc libmount libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre procps-ng sudo tar which xz-libs zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg unpack postgresql-client-10.11.0-0 --checksum 7698c1aeb96133009652bfe6b05713c2450effcdc53f094194d06fe15a04f580
RUN bitnami-pkg install java-11.0.6-0 --checksum 44f5ec63dbe8d2ea9aaea237cec2d8821ac3ee6fa2812c295c0fa04068d0e08e
RUN bitnami-pkg unpack sonarqube-8.1.0-0 --checksum 074fed9aac05e6017e4dcfbad4ed1b6aa1aa60fda4f112b6a907da6b3adf643d
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="sonarqube" \
    BITNAMI_IMAGE_VERSION="8.1.0-ol-7-r42" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_NAME="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME="" \
    POSTGRESQL_HOST="postgresql" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_ROOT_PASSWORD="" \
    POSTGRESQL_ROOT_USER="postgres" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER="" \
    SONARQUBE_CE_JAVA_ADD_OPTS="" \
    SONARQUBE_DATABASE_NAME="bitnami_sonarqube" \
    SONARQUBE_DATABASE_PASSWORD="" \
    SONARQUBE_DATABASE_USER="bn_sonarqube" \
    SONARQUBE_ELASTICSEARCH_JAVA_ADD_OPTS="" \
    SONARQUBE_ELASTICSEARCH_PORT_NUMBER="9001" \
    SONARQUBE_ENABLE_DEMO_DATA="no" \
    SONARQUBE_PASSWORD="bitnami" \
    SONARQUBE_PORT_NUMBER="9000" \
    SONARQUBE_START_TIMEOUT="300" \
    SONARQUBE_USERNAME="admin" \
    SONARQUBE_WEB_CONTEXT="/" \
    SONARQUBE_WEB_JAVA_ADD_OPTS=""

EXPOSE 9000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "sonarqube" ]
