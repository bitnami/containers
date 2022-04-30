FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libicu63 liblzma5 libncurses6 libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.332-0" --checksum ea45a7908b8a86363659aa7e3953a1308af86db3ffa1656e46036c8e1f7c659a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wildfly" "14.0.1-29" --checksum bd45269cbe0ede67add50d124f0353f11e02da3b787299fef0b764aba30a54a8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.7-4" --checksum 14329a8ec0a649ecb9ffb37085a547183748efedea8ed029801ab9b381ab7173
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ejbca" "7.4.3-2-7" --checksum 79b207983ce3fbf498e9da68d496b92b140a80b18648463c14a23cdffb01af36
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/ejbca/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="7.4.3-2" \
    BITNAMI_APP_NAME="ejbca" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/wildfly/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/ejbca/bin:$PATH"

EXPOSE 8009 8080 9990

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/ejbca/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/ejbca/run.sh" ]
