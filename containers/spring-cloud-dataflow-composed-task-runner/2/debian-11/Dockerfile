FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc-s1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.333-151" --checksum e0b96c241eeb16c7ba019193535c4d5c2b447a479d7f2056081f496eafbb94c7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-dataflow-composed-task-runner" "2.9.4-151" --checksum 204ef55185ed7096a3d86f516dbe02a9718f2b403d1c16920d4ec7fb1e5a4502
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.m2 && chmod -R g+rwX /.m2

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="2.9.4" \
    BITNAMI_APP_NAME="spring-cloud-dataflow-composed-task-runner" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/scdf-composed-task-runner/entrypoint.sh" ]
CMD [ "--help" ]
