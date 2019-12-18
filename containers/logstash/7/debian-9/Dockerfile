FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libgcc1 procps unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "logstash" "7.5.0-0" --checksum 950ae36e5392e8106580246e11a10f9f255659d730e40a0604af4b79a5de6e8a
RUN . ./libcomponent.sh && component_unpack "java" "1.8.232-0" --checksum f4e5ff1d4fb13baf9bb2a4f2e5ffb328cf9eeb26d0b91214196e4473c2874adc
RUN curl --silent -L https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 > /usr/local/bin/gosu && \
    echo 0b843df6d86e270c5b0f5cbd3c326a04e18f4b7f9b8457fa497b0454c4b138d7 /usr/local/bin/gosu | sha256sum --check && \
    chmod u+x /usr/local/bin/gosu && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/tianon/gosu/master/LICENSE > /opt/bitnami/licenses/gosu-1.11.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="logstash" \
    BITNAMI_IMAGE_VERSION="7.5.0-debian-9-r12" \
    PATH="/opt/bitnami/logstash/bin:/opt/bitnami/java/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/logstash
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
