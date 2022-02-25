FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.14-6" --checksum 8e9d15dc54b3cf57e7f3b92efbb1e01ed07f002889034ec7703b62efb8265243
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wildfly" "26.0.1-8" --checksum d7dc4756b86180b542f503c1a510c433f3d862800dec3217b56450e12a014d87
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-6" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/wildfly/postunpack.sh
ENV BITNAMI_APP_NAME="wildfly" \
    BITNAMI_IMAGE_VERSION="26.0.1-debian-10-r35" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/wildfly/bin:/opt/bitnami/common/bin:$PATH" \
    WILDFLY_HOME="/home/wildfly"

EXPOSE 8080 9990

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wildfly/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/wildfly/run.sh" ]
