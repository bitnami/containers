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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.14-4" --checksum 6dbd1da27fbf2f1a92fcf8e58bf873736aa65428cdaff26708ec7506e03cc8e7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tomcat" "9.0.58-6" --checksum 0811acd6e5598db328349579bcad45d18998bea7803cc5f4a93cd920d35a45a5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.32-31" --checksum 4489feca3a65fbd733774d193b02914187451c6edf27855ebc5756e45a9f299e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "reportserverenterprise" "4.0.0-6055-1" --checksum b221c2c934b0002f729806443a606c31cf2b3f1e72e0fb2b83ee73a18739b1ce
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-7" --checksum ed811d10882450d4755b893d5e034a0dd912cdb4f261dd332ddf6363411cc0ba
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/reportserver/postunpack.sh
RUN /opt/bitnami/scripts/tomcat/postunpack.sh
ENV BITNAMI_APP_NAME="reportserverenterprise" \
    BITNAMI_IMAGE_VERSION="4.0.0-6055-debian-10-r1" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:$PATH" \
    TOMCAT_START_RETRIES="60"

EXPOSE 8009 8080

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/reportserver/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tomcat/run.sh" ]
