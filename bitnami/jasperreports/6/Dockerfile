FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libfontconfig1 libfreetype6 libgcc1 libglib2.0-0 liblzma5 libncurses5 libpcre3 libpng12-0 libselinux1 libssl1.0.0 libstdc++6 libtinfo5 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 zlib1g
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27
RUN bitnami-pkg install tomcat-8.0.44-0 --checksum eb24b14dd7061bad4ab9a311838c911419b4b61c8c5c13aedf06a7a29305b426
RUN bitnami-pkg install mysql-client-10.1.24-0 --checksum 3ac33998eefe09a8013036d555f2a8265fc446a707e8d61c63f8621f4a3e5dae
RUN bitnami-pkg unpack jasperreports-6.4.0-0 --checksum f95828097c78efaf18166eeb0999ace6204beeb33168a0da1f604dbc87063b7c

COPY rootfs /

ENV BITNAMI_APP_NAME="jasperreports" \
    BITNAMI_IMAGE_VERSION="6.4.0-r0" \
    JASPERREPORTS_EMAIL="user@example.com" \
    JASPERREPORTS_PASSWORD="bitnami" \
    JASPERREPORTS_USERNAME="user" \
    MARIADB_HOST="mariadb" \
    MARIADB_PASSWORD="" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_USER="root" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:$PATH" \
    SMTP_EMAIL="" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_PROTOCOL="" \
    SMTP_USER=""




EXPOSE 8080 8443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","tomcat"]
