FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/sonarqube/bin/linux-x86-64/:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr gnupg libblkid1 libbsd0 libc6 libedit2 libffi6 libgcc1 libglib2.0-0 libgmp10 libgnutls30 libhogweed4 libicu63 libidn2-0 libldap-2.4-2 liblzma5 libmount1 libnettle6 libp11-kit0 libpcre3 libsasl2-2 libselinux1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 procps sudo unzip zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg unpack postgresql-client-10.12.0-2 --checksum d410e1b0444e7ca41bc12ef379e435ac4c44263a51eac8f3d455115b5084fd00
RUN bitnami-pkg install java-11.0.6-0 --checksum f7446f8bec72b6b2606d37ba917accc243e6cd4e722700c39ef83832c46fb0c6
RUN bitnami-pkg install tini-0.18.0-3 --checksum 1e9b72b6636c6a48397a18df2363b44461e87ad7f892c179a9115c7525ed9327
RUN bitnami-pkg unpack sonarqube-7.9.3-0 --checksum dbb2a16ef2c138ed2f8bef884a43f05ad624c89e55d0974147e90fba54dab1af
RUN bitnami-pkg install gosu-1.11.0-3 --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
ENV BITNAMI_APP_NAME="sonarqube" \
    BITNAMI_IMAGE_VERSION="7.9.3-debian-10-r2" \
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
