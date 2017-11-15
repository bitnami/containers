FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libncurses5 libssl1.0.0 libstdc++6 libtinfo5 zlib1g
RUN bitnami-pkg install java-1.8.151-0 --checksum fbbea572d89988035aee16eefe53c852e8abfda84f6c7cf5c9a4772a72863143
RUN bitnami-pkg unpack tomcat-8.0.47-0 --checksum a000250a8120818d332d099114da7d8b9f28052487a286953257d2a651c53358
RUN bitnami-pkg install mysql-client-10.1.29-0 --checksum 4b29436697f5fcdf38f3c9713a27208304fe36b858afc5aa5a7a4d3f17d84bac
RUN bitnami-pkg unpack jasperreports-6.4.2-0 --checksum 8273f329f4369c0010dfd41b08dcc488ecdef5ac40f6c87e628c282c302660ae

COPY rootfs /

ENV BITNAMI_APP_NAME="jasperreports" \
    BITNAMI_IMAGE_VERSION="6.4.2-r0" \
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
    SMTP_USER="" \
    TOMCAT_AJP_PORT_NUMBER="8009" \
    TOMCAT_ALLOW_REMOTE_MANAGEMENT="0" \
    TOMCAT_HTTP_PORT_NUMBER="8080" \
    TOMCAT_PASSWORD="" \
    TOMCAT_SHUTDOWN_PORT_NUMBER="8005" \
    TOMCAT_USERNAME="user"

EXPOSE 8080 8443

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","tomcat"]
