FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/opt/bitnami/rabbitmq/.rabbitmq" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/erlang/bin:/opt/bitnami/rabbitmq/sbin:/opt/bitnami/common/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libssl1.1 libtinfo6 locales procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "erlang" "23.3.4-0" --checksum b340674294db820b126087f9dec2bd3a0fa17a8f83928d963d77095652d75cad
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "rabbitmq" "3.8.16-0" --checksum 93935c2472c6f7515e4f58883dfdfec4cec2e16630df091d01468929e9f95ed8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN chmod g+rwX /opt/bitnami
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /opt/bitnami/scripts/rabbitmq/postunpack.sh
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
ENV BITNAMI_APP_NAME="rabbitmq" \
    BITNAMI_IMAGE_VERSION="3.8.16-debian-10-r11" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en"

EXPOSE 4369 5671 5672 15671 15672 25672

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/rabbitmq/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/rabbitmq/run.sh" ]
