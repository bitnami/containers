FROM bitnami/oraclelinux-extras:7-r437
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glib2 glibc keyutils-libs krb5-libs libblkid libcom_err libedit libffi libgcc libmount libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nss-softokn-freebl openssl-libs pcre xz-libs zlib
RUN bitnami-pkg unpack postgresql-client-10.10.0-0 --checksum 877059a02935507bb3c55ba60948dde36f7a0079cb4236abae325dbb5fde675a
RUN bitnami-pkg install java-11.0.4-0 --checksum 3a17c3d9c943fc8342a9aa9786e924627d5b5579163e957d0ca1c9de523626f3
RUN bitnami-pkg unpack sonarqube-7.9.1-1 --checksum 2ce717017cdaee099397ca8e918feb75e4ed862e4f78a71b092c887e5350d8a8

COPY rootfs /
ENV BITNAMI_APP_NAME="sonarqube" \
    BITNAMI_IMAGE_VERSION="7.9.1-ol-7-r45" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/java/bin:/opt/bitnami/sonarqube/bin/linux-x86-64/:$PATH" \
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
    SONARQUBE_USERNAME="admin" \
    SONARQUBE_WEB_CONTEXT="/" \
    SONARQUBE_WEB_JAVA_ADD_OPTS=""

EXPOSE 9000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "sonarqube" ]
