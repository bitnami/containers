FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio-devel libgcc procps-ng sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "logstash" "7.5.2-1" --checksum 4bbadedda71fde025f397b337aa291f703759e0ab878fee505841f03c1a49fa4
RUN . ./libcomponent.sh && component_unpack "java" "1.8.242-0" --checksum 974f750091ac1bf18cc1ce9472ef5ed7c1b328a2c17471cb9ac810fcded67151
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="logstash" \
    BITNAMI_IMAGE_VERSION="7.5.2-ol-7-r12" \
    PATH="/opt/bitnami/logstash/bin:/opt/bitnami/java/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/logstash
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
