FROM bitnami/oraclelinux-extras-base:7-r449
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc libgcc zlib
RUN . ./libcomponent.sh && component_unpack "logstash" "7.4.0-0" --checksum 9962025a61b53cc9eeccc6da5ded1ab0e4e6f0dc512ad23922ff430e03ab4f9e
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-1" --checksum 664cacaa11342e877410b197d21343543c2987cd66f15d2adc32cc61eee48eaa

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="logstash" \
    BITNAMI_IMAGE_VERSION="7.4.0-ol-7-r5" \
    PATH="/opt/bitnami/logstash/bin:/opt/bitnami/java/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/logstash
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
