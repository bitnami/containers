FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gzip libc6 openssh-client procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "dumb-init" "1.2.5-6" --checksum fb6f4aaea8eec3a025b7442fcc4bb3e07fa00c331cfea9680851019b516d95f5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "docker-machine" "0.16.2-6" --checksum 2b184a3bb0f736ef9a97fd25d4c734467be0c13d8381608895c3267c0d0c356b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gitlab-runner" "14.10.0-0" --checksum 2bef858dcdfae5e1092bb7394938475c06edb464af896abd04f7f9cdebe61a88
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN mkdir /home/gitlab-runner && chmod -R g+rwX /home/gitlab-runner && ln -s /opt/bitnami/common/bin/dumb-init /usr/bin/dumb-init && ln -s /opt/bitnami/scripts/gitlab-runner/entrypoint.sh /entrypoint
ENV APP_VERSION="14.10.0" \
    BITNAMI_APP_NAME="gitlab-runner" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/gitlab-runner/bin:$PATH"

USER 1001
ENTRYPOINT [ "/usr/bin/dumb-init", "/opt/bitnami/scripts/gitlab-runner/entrypoint.sh" ]
CMD [ "run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner" ]
