FROM bitnami/oraclelinux-extras:7-r323
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glib2 glibc keyutils-libs krb5-libs libblkid libcom_err libedit libffi libgcc libmount libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nss-softokn-freebl openssl-libs pcre xz-libs zlib
RUN bitnami-pkg unpack postgresql-client-10.7.0-0 --checksum 8984b9748b6b696ca687c769b324371132c01ea9b71b4773a3d199f1987a6761
RUN bitnami-pkg install java-1.8.212-0 --checksum 7d11dad71234819fb290bcadc2997bda088ba6b21f245d397c068de4cf3757db
RUN bitnami-pkg unpack sonarqube-7.7.0-0 --checksum 27d14ca3520ab3031157cdcb841616f92033280f16fcb0ba7e20ae808d5954cc

COPY rootfs /
ENV BITNAMI_APP_NAME="sonarqube" \
    BITNAMI_IMAGE_VERSION="7.7.0-ol-7-r23" \
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
    SONARQUBE_DATABASE_NAME="bitnami_sonarqube" \
    SONARQUBE_DATABASE_PASSWORD="" \
    SONARQUBE_DATABASE_USER="bn_sonarqube" \
    SONARQUBE_ELASTICSEARCH_PORT_NUMBER="9001" \
    SONARQUBE_ENABLE_DEMO_DATA="no" \
    SONARQUBE_JAVA_OPTS="" \
    SONARQUBE_PASSWORD="bitnami" \
    SONARQUBE_PORT_NUMBER="9000" \
    SONARQUBE_USERNAME="admin" \
    SONARQUBE_WEB_CONTEXT="/"

EXPOSE 9000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "sonarqube" ]
