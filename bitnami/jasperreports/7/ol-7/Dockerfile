FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages audit-libs ca-certificates curl cyrus-sasl-lib fontconfig freetype glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcap-ng libcom_err libcurl libgcc libidn libselinux libssh2 libstdc++ ncurses-libs nspr nss nss-softokn-freebl nss-util openldap openssl-libs pam pcre procps-ng sudo tar which zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install java-1.8.242-0 --checksum 974f750091ac1bf18cc1ce9472ef5ed7c1b328a2c17471cb9ac810fcded67151
RUN bitnami-pkg unpack tomcat-9.0.31-1 --checksum 49b5edd7a49b0a185650ab69ab568bbee47bf2259783bf49c8831d51ddd558e2
RUN bitnami-pkg unpack mysql-client-10.3.22-1 --checksum a619b82859b607462a5a82900fea0c19665857ff26c2f4506752a82368b66f72
RUN bitnami-pkg unpack jasperreports-7.2.0-2 --checksum 712f67da04894ed4f3dd4134b8a1baf47c9483507fbbaef6184623c8cb35aeb3
RUN bitnami-pkg install git-2.25.1-0 --checksum 037457371b4782c6e780a899463a54544590a20a12c344bf5d14cef5ef470077
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="jasperreports" \
    BITNAMI_IMAGE_VERSION="7.2.0-ol-7-r260" \
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
    SMTP_EMAIL="" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""

EXPOSE 8080 8443

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "tomcat" ]
