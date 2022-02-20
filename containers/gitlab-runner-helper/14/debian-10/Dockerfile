FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gzip libc6 openssh-client procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "dumb-init" "1.2.5-5" --checksum 91ad4e7dce435d4d743f9d6579505034067f7ee8e9e8cfd581a22c5e5272492c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-6" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gitlab-runner-helper" "14.7.0-5" --checksum 59c8ceaf5eb208c4025c645b5a93b0f0301c6300b33bec42d3a513c391b9a7d9
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN mkdir /home/gitlab-runner && chmod -R g+rwX /home/gitlab-runner && ln -s /opt/bitnami/common/bin/dumb-init /usr/bin/dumb-init && ln -s /opt/bitnami/scripts/gitlab-runner-helper/entrypoint.sh /entrypoint
ENV BITNAMI_APP_NAME="gitlab-runner-helper" \
    BITNAMI_IMAGE_VERSION="14.7.0-debian-10-r30" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/gitlab-runner-helper/bin:$PATH"

USER 1001
ENTRYPOINT [ "/usr/bin/dumb-init", "/opt/bitnami/scripts/gitlab-runner-helper/entrypoint.sh" ]
CMD [ "sh" ]
