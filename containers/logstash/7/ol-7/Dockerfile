FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio-devel libgcc procps-ng sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "logstash" "7.5.1-0" --checksum 0ba07df2f1f63e8a51e83c11a3bca94fe978d63e43f88648cf60c7c6dbe88bb9
RUN . ./libcomponent.sh && component_unpack "java" "1.8.232-0" --checksum fbac74363c807fce14538c5f9a9232602adc7883c1c5936571c741625de2479e
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN curl --silent -L https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 > /usr/local/bin/gosu && \
    echo 0b843df6d86e270c5b0f5cbd3c326a04e18f4b7f9b8457fa497b0454c4b138d7 /usr/local/bin/gosu | sha256sum --check && \
    chmod u+x /usr/local/bin/gosu && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/tianon/gosu/master/LICENSE > /opt/bitnami/licenses/gosu-1.11.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="logstash" \
    BITNAMI_IMAGE_VERSION="7.5.1-ol-7-r15" \
    PATH="/opt/bitnami/logstash/bin:/opt/bitnami/java/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/logstash
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
