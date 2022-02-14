FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gzip libc6 openssh-client procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "dumb-init" "1.2.5-3" --checksum 562a02f578bf017eca0fc22a39597edfb5b3fea4e5dcc6cc85e5c39655b569ce
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "docker-machine" "0.16.2-3" --checksum 1f99dbad9e00fc30b16ebcf15b7a812a9f68ffdb604233c070c04d3780fc5075
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gitlab-runner" "14.7.0-3" --checksum 2b5273b8654569e8f059f892f3301ed4fe1110b3b27dd75190b71355b0219062
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN mkdir /home/gitlab-runner && chmod -R g+rwX /home/gitlab-runner && ln -s /opt/bitnami/common/bin/dumb-init /usr/bin/dumb-init && ln -s /opt/bitnami/scripts/gitlab-runner/entrypoint.sh /entrypoint
ENV BITNAMI_APP_NAME="gitlab-runner" \
    BITNAMI_IMAGE_VERSION="14.7.0-debian-10-r25" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/gitlab-runner/bin:$PATH"

USER 1001
ENTRYPOINT [ "/usr/bin/dumb-init", "/opt/bitnami/scripts/gitlab-runner/entrypoint.sh" ]
CMD [ "run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner" ]
