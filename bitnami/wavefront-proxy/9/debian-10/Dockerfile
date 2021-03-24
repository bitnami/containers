FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.10-0" --checksum 68b909cfb5c98625e7d0db5c6eb82a34eca9b8940ada38b7eaa0c238bb510b57
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wavefront-proxy" "9.6.0-0" --checksum 9544277281e873f0af8333f9010534e9f0257dd1f52a17e378544358ce83440a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/wavefront-proxy/postunpack.sh
ENV BITNAMI_APP_NAME="wavefront-proxy" \
    BITNAMI_IMAGE_VERSION="9.6.0-debian-10-r7" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 2878

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wavefront-proxy/entrypoint.sh" ]
CMD [ "/opt/bitnami/wavefront-proxy/scripts/run.sh" ]
