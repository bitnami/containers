FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gzip libc6 openssh-client procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "dumb-init" "1.2.5-1" --checksum d5425adcd16cdd060e57e8173750073e94695efeaaa36fb9332f0e63abf39ea4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-2" --checksum 7419bc5e2be68eb14c92e321acc843413481cda73323fb8c0d1dda8b1e5aa9d5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gitlab-runner-helper" "14.7.0-1" --checksum f92a9d92e3c77dac0cd35bafd96c18af2fb01444487cb6b71efc2c2c361e0118
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN mkdir /home/gitlab-runner && chmod -R g+rwX /home/gitlab-runner && ln -s /opt/bitnami/common/bin/dumb-init /usr/bin/dumb-init && ln -s /opt/bitnami/scripts/gitlab-runner-helper/entrypoint.sh /entrypoint
ENV BITNAMI_APP_NAME="gitlab-runner-helper" \
    BITNAMI_IMAGE_VERSION="14.7.0-debian-10-r1" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/gitlab-runner-helper/bin:$PATH"

USER 1001
ENTRYPOINT [ "/usr/bin/dumb-init", "/opt/bitnami/scripts/gitlab-runner-helper/entrypoint.sh" ]
CMD [ "sh" ]
