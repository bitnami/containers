FROM bitnami/minideb-extras:stretch-r415
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libblkid1 libbsd0 libc6 libedit2 libffi6 libgcc1 libglib2.0-0 libicu57 liblzma5 libmount1 libncurses5 libpcre3 libselinux1 libssl1.1 libstdc++6 libtinfo5 libuuid1 libxml2 libxslt1.1 zlib1g
RUN bitnami-pkg unpack postgresql-client-10.9.0-0 --checksum 1a1b4b3f6582abf88a6d109c0f55a65496f0a23b5fadc0b8642800d4d29179e0
RUN bitnami-pkg install java-11.0.3-0 --checksum 7085787447348f2b80fcaf65247204203b6d4ced6d72eb1d7ce77afe317e3142
RUN bitnami-pkg unpack sonarqube-7.9.1-0 --checksum e88e7e8b112b823141365babdaf0ec407841c1f0e18eed1c662d28f9479fad69

COPY rootfs /
ENV BITNAMI_APP_NAME="sonarqube" \
    BITNAMI_IMAGE_VERSION="7.9.1-debian-9-r1" \
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
