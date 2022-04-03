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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-8" --checksum d5670d09ac0e679ae28306e417e77e91b44051908ca3a82259efcd70764b996f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.24.2-0" --checksum 6671445790516400883182abf5e957645260585b8a9f9432a8a6b63b045b6559
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-skipper" "2.8.3-0" --checksum 1933ff0d8abac02ba7d08f6257ed682375f2e166cc62f69a59738a991b53be65
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/spring-cloud-skipper/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="2.8.3" \
    BITNAMI_APP_NAME="spring-cloud-skipper" \
    BITNAMI_IMAGE_VERSION="2.8.3-debian-10-r9" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spring-cloud-skipper/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spring-cloud-skipper/run.sh" ]
