FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaudit1 libc6 libcap-ng0 libgcc1 libicu63 libjemalloc2 liblzma5 libncurses6 libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 procps tar xmlstarlet zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.14-7" --checksum 900545c4f346a0ece8abf2caf64fd9d4ab7514967d4614d716bf7362b24f828b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tomcat" "9.0.59-0" --checksum f6f3600acc829e773a223f2f76f65b512451cfb9b1a0b6feca580de4fa7bf95e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.34-4" --checksum bb0089c26028b568dbe8b8875d39cca3c7835c582dda4fcbdcbed599320c57fe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "reportserver" "4.0.0-6055-4" --checksum 569c3c39174c01f7f7a4efd5f18848a4454cb175b9dcf04004a09ab016c2ee7a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 97c2ae4b001c5937e888b920bee7b1a40a076680caac53ded6d10f6207d54565
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/reportserver/postunpack.sh
RUN /opt/bitnami/scripts/tomcat/postunpack.sh
ENV BITNAMI_APP_NAME="reportserver" \
    BITNAMI_IMAGE_VERSION="4.0.0-6055-debian-10-r17" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:$PATH" \
    TOMCAT_START_RETRIES="60"

EXPOSE 8009 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/reportserver/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tomcat/run.sh" ]
