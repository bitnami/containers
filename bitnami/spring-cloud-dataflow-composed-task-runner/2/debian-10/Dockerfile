FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-5" --checksum 5bea54f21135133d1d0df7486e419d204f846d8acac4c83e1c6359a703fc9244
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-dataflow-composed-task-runner" "2.9.2-4" --checksum 288be0612a5d2fc75398d37f8ad3a4c71de108b8145434636620d723f535143f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.m2 && chmod -R g+rwX /.m2

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="spring-cloud-dataflow-composed-task-runner" \
    BITNAMI_IMAGE_VERSION="2.9.2-debian-10-r23" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/scdf-composed-task-runner/entrypoint.sh" ]
CMD [ "--help" ]
