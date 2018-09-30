FROM bitnami/oraclelinux-extras:7-r122
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glib2 glibc keyutils-libs krb5-libs libblkid libcom_err libffi libgcc libmount libselinux libstdc++ libuuid libxml2 libxslt ncurses-libs nss-softokn-freebl openssl-libs pcre readline xz-libs zlib
RUN bitnami-pkg unpack postgresql-client-10.5.0-0 --checksum f3a5894a09eec21e95caa4ef9f5e1c7dfe906e1ae1075ba70f0ef6d6e4e2585e
RUN bitnami-pkg install java-1.8.181-1 --checksum 6e7fc2779b6e0e3c6c0a2687b1d747d8a427594ff80b8c94b055c839e387e6b1
RUN bitnami-pkg unpack sonarqube-7.3.0-2 --checksum 8caecba3fdb5eff1db16a7a2cbc8cfad27eeac56178f784b998d0ca3736d916b

COPY rootfs /
ENV BITNAMI_APP_NAME="sonarqube" \
    BITNAMI_IMAGE_VERSION="7.3.0-ol-7-r3" \
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
    SONARQUBE_ELASTICSEARCH_PORT_NUMBER="" \
    SONARQUBE_ENABLE_DEMO_DATA="no" \
    SONARQUBE_JAVA_OPTS="" \
    SONARQUBE_PASSWORD="bitnami" \
    SONARQUBE_PORT_NUMBER="" \
    SONARQUBE_USERNAME="admin"

EXPOSE 9000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "sonarqube" ]
