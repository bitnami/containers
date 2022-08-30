FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="8.0.2-debian-11-r28" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/jasperreports" \
      org.opencontainers.image.title="jasperreports" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="8.0.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig git gzip libaudit1 libbsd0 libc6 libcap-ng0 libedit2 libffi7 libgcc-s1 libgmp10 libgnutls30 libhogweed6 libicu67 libidn2-0 libldap-2.4-2 liblzma5 libmd0 libncurses6 libnettle8 libp11-kit0 libpam0g libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 procps tar xmlstarlet zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.345-2" --checksum b244bc8c1f972d20fac8019cf97fb05ce6cd8be2034ca11f52243c8bd96aaa23
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tomcat" "9.0.65-4" --checksum 1db8854359f51582bfb01878d600e582dfcdb01456cc8276a0ace34e0543440f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.17.0-1" --checksum d34624cbd7e1905269ad7d873efe3cad0687bcf52dd822c84ad70c61bca180de
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.9-1" --checksum 14ae2f6d8d5f4e3a9e4cf62d5a3da80587a20651a5920dbc4ac89afdaf06f8c0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-153" --checksum c1f2cdabdcc920512e8936ab2c8a033e1aeb97801fa026f0b12432581bf849ae
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "jasperreports" "8.0.2-154" --checksum fbab4bb67de22e7aaf8bd6c6080d367a95ee05116884482d3c521f094e17974f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/tomcat/postunpack.sh
RUN /opt/bitnami/scripts/jasperreports/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV APP_VERSION="8.0.2" \
    BITNAMI_APP_NAME="jasperreports" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8009 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/jasperreports/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tomcat/run.sh" ]
