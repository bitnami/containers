FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

ARG ELASTICSEARCH_PLUGINS=""
ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip hostname libasound2-dev libc6 libfreetype6 libfreetype6-dev libgcc1 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.16.2-0" --checksum 8200ea4477d139cb9be607a962760075e9240a760b56fb2f1f870a7facbf3e69
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.13-0" --checksum 9552e53ccd3b0ec85a82c31c26a1462260e28b7c58770a5c53560afb02ec66d9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "elasticsearch" "7.16.2-0" --checksum 6a4b552c05bbfe3d242d561928c205543a981b8693aa0d5b01e2cf532a26b708
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/elasticsearch/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="7.16.2-debian-10-r13" \
    JAVA_HOME="/opt/bitnami/java" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/elasticsearch/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/elasticsearch/run.sh" ]
