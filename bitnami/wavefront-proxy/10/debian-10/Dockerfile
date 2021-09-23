FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.12-0" --checksum 14c1274e93b1135d4d1b82ad7985fc2fa7f5d0689b6da18e0c94da37407cd4ea
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wavefront-proxy" "10.8.0-0" --checksum 190da1a600daeacd9a57181287e980beda3fa7b629a412450edccca2b75b4f49
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/wavefront-proxy/postunpack.sh
ENV BITNAMI_APP_NAME="wavefront-proxy" \
    BITNAMI_IMAGE_VERSION="10.8.0-debian-10-r15" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 2878

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wavefront-proxy/entrypoint.sh" ]
CMD [ "/opt/bitnami/wavefront-proxy/scripts/run.sh" ]
