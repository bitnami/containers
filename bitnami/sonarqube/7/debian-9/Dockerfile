FROM bitnami/minideb-extras:stretch-r366
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libblkid1 libbsd0 libc6 libedit2 libffi6 libgcc1 libglib2.0-0 libicu57 liblzma5 libmount1 libncurses5 libpcre3 libselinux1 libssl1.1 libstdc++6 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack postgresql-client-10.8.0-0 --checksum 5eb093f7d87e9eca63e558644e428ea72fe4ea0e845741203dcc2cd8e8791d83
RUN bitnami-pkg install java-1.8.212-0 --checksum 54a18672c8b4c1a44324c607a6bc616f614a062005d5e3384f91f10ff6f6edea
RUN bitnami-pkg unpack sonarqube-7.7.0-0 --checksum ee1e0075d334dfa729be7e89495d62d4530d711b43138d02c0a8db8fe162de34

COPY rootfs /
ENV BITNAMI_APP_NAME="sonarqube" \
    BITNAMI_IMAGE_VERSION="7.7.0-debian-9-r26" \
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
