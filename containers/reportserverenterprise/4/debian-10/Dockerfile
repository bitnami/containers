FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig fonts-dejavu-extra gzip libaudit1 libc6 libcap-ng0 libgcc1 libicu63 libjemalloc2 liblzma5 libncurses6 libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 procps tar xmlstarlet zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.14-5" --checksum 8e9d15dc54b3cf57e7f3b92efbb1e01ed07f002889034ec7703b62efb8265243
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tomcat" "9.0.58-7" --checksum 5b5e92174e2174ab1a86c5ee2c32e4939638300cef60222b6e23dbfb76b49074
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.34-1" --checksum e4111d4f7ed30cafbf80e97f6fae69787445517a7a18c5a0dcca23360cf185ae
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "reportserverenterprise" "4.0.0-6055-2" --checksum 231cefa1980511940e4b4c801f57f8351ea8eab3ffe2fd0a3560f7b12d37e2ef
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-8" --checksum 4694f01476c5a457a71f280562df45ea542bdf3f9b298ff87643a89ea365f5fb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-5" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/reportserver/postunpack.sh
RUN /opt/bitnami/scripts/tomcat/postunpack.sh
ENV BITNAMI_APP_NAME="reportserverenterprise" \
    BITNAMI_IMAGE_VERSION="4.0.0-6055-debian-10-r6" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:$PATH" \
    TOMCAT_START_RETRIES="60"

EXPOSE 8009 8080

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/reportserver/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tomcat/run.sh" ]
