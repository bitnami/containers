FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl fontconfig gzip libaudit1 libc6 libcap-ng0 libcom-err2 libcurl4 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libxml2 procps sudo tar zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install java-1.8.275-0 --checksum 81e35af4a12129edc3d2fdd6fd7c4fab2dbdd5fba74eab6fe4576381867a55ab
RUN bitnami-pkg unpack tomcat-9.0.41-2 --checksum 75599ca1ca57f12404feb8cdb93b867c2e4faeb0c70edc16c4ca07c02ca480fb
RUN bitnami-pkg unpack mysql-client-10.3.27-0 --checksum f96905e763a6334b75a7cdb07f8d89658cde02be41cb09d91d0682fc649fdcff
RUN bitnami-pkg install git-2.30.0-0 --checksum da1ad2f9c18b54f8b382df278b29da9b2c870aae3a16783a740b0d9d28c5e0fb
RUN bitnami-pkg install tini-0.19.0-1 --checksum 9b1f1c095944bac88a62c1b63f3bff1bb123aa7ccd371c908c0e5b41cec2528d
RUN bitnami-pkg unpack jasperreports-7.8.0-4 --checksum c17c0aba6c9be740a9a3e438ffc64e321be86d7a4d0af4b6c43d2be42ce4ad21
RUN bitnami-pkg install gosu-1.12.0-2 --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="jasperreports" \
    BITNAMI_IMAGE_VERSION="7.8.0-debian-10-r105" \
    JASPERREPORTS_DATABASE_NAME="bitnami_jasperreports" \
    JASPERREPORTS_DATABASE_PASSWORD="" \
    JASPERREPORTS_DATABASE_USER="bn_jasperreports" \
    JASPERREPORTS_EMAIL="user@example.com" \
    JASPERREPORTS_PASSWORD="bitnami" \
    JASPERREPORTS_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    MYSQL_CLIENT_ENABLE_SSL="no" \
    MYSQL_CLIENT_SSL_CA_FILE="" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    SMTP_EMAIL="" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 8080 8443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "tomcat" ]
