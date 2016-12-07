FROM gcr.io/stacksmith-images/minideb:jessie-r5

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=jasperreports \
    BITNAMI_IMAGE_VERSION=6.3.0-r4 \
    PATH=/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin/:$PATH

# System packages required
RUN install_packages libc6 libxext6 libx11-6 libxcb1 libxau6 libxdmcp6 libglib2.0-0 libfreetype6 libfontconfig1 libstdc++6 libgcc1 zlib1g libselinux1 libpng12-0 libexpat1 libffi6 libpcre3 libxml2 liblzma5 libssl1.0.0 libncurses5 libtinfo5

# Additional modules required
RUN bitnami-pkg install java-1.8.0_111-1 --checksum f7705a3955f006eb59a6e4240a01d8273b17ba38428d30ffe7d10c9cc525d7be
RUN bitnami-pkg install tomcat-8.0.39-3 --checksum 0b84cb324fa971d610eadbc7db1b2b00c8ca7a97ae4c527f193a94340f489c71
RUN bitnami-pkg install mysql-client-10.1.19-1 --checksum 2d946c8ee3e2e845f68a5cf3751d6477d88af194d263842797fe50a44414a173

# Install jasperreports
RUN bitnami-pkg unpack jasperreports-6.3.0-1 --checksum bfb22b415e4b0d33a6306f9a6971bc4f69802a46606e0a2cbfc746f09d9831cd

COPY rootfs /

VOLUME ["/bitnami/jasperreports"]

EXPOSE 8080 8443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "tomcat"]
