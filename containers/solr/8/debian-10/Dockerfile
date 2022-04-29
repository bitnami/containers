FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 lsof netcat-traditional procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.332-0" --checksum ea45a7908b8a86363659aa7e3953a1308af86db3ffa1656e46036c8e1f7c659a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "solr" "8.11.1-7" --checksum dc6035aa6abf722ac025ff953b57f0e121e781a26cf412e176a57574c86487b1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/solr/postunpack.sh
ENV APP_VERSION="8.11.1" \
    BITNAMI_APP_NAME="solr" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/solr/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/solr/run.sh" ]
