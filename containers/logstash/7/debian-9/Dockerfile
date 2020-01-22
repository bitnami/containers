FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libgcc1 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "logstash" "7.5.2-0" --checksum c8052a71cc54dce0c3aecc2a30dd7f0a2de3619af0de81ab9e450fed29c4834f
RUN . ./libcomponent.sh && component_unpack "java" "1.8.232-0" --checksum f4e5ff1d4fb13baf9bb2a4f2e5ffb328cf9eeb26d0b91214196e4473c2874adc
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="logstash" \
    BITNAMI_IMAGE_VERSION="7.5.2-debian-9-r0" \
    PATH="/opt/bitnami/logstash/bin:/opt/bitnami/java/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/logstash
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
