FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="15.3.0-debian-11-r0" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/gitlab-runner" \
      org.opencontainers.image.title="gitlab-runner" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="15.3.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gzip libc6 openssh-client procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "dumb-init" "1.2.5-152" --checksum 8b0e728cd7add1976d252570b26d6dc946de59a4604adceee8f04152258b5947
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "docker-machine" "0.16.2-152" --checksum ffc0b36315382d01ceace9e2a73609b023d27ae14b32e7f3637c61ef7bbc9007
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gitlab-runner" "15.3.0-0" --checksum 91df102ad128c591045d297607ac3ef94539bec598860d442b72b1a92fab591f
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN mkdir /home/gitlab-runner && chmod -R g+rwX /home/gitlab-runner && ln -s /opt/bitnami/common/bin/dumb-init /usr/bin/dumb-init && ln -s /opt/bitnami/scripts/gitlab-runner/entrypoint.sh /entrypoint
ENV APP_VERSION="15.3.0" \
    BITNAMI_APP_NAME="gitlab-runner" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/gitlab-runner/bin:$PATH"

USER 1001
ENTRYPOINT [ "/usr/bin/dumb-init", "/opt/bitnami/scripts/gitlab-runner/entrypoint.sh" ]
CMD [ "run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner" ]
