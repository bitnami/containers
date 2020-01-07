FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio-devel libgcc procps-ng sudo tar unzip which zlib
RUN . ./libcomponent.sh && component_unpack "java" "1.8.232-0" --checksum fbac74363c807fce14538c5f9a9232602adc7883c1c5936571c741625de2479e
RUN . ./libcomponent.sh && component_unpack "kafka" "2.4.0-0" --checksum 21b2cb36f6ee34fb350c92fb40538b1c155388fddc4d5e9746aa738494355855
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN curl --silent -L https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 > /usr/local/bin/gosu && \
    echo 0b843df6d86e270c5b0f5cbd3c326a04e18f4b7f9b8457fa497b0454c4b138d7 /usr/local/bin/gosu | sha256sum --check && \
    chmod u+x /usr/local/bin/gosu && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/tianon/gosu/master/LICENSE > /opt/bitnami/licenses/gosu-1.11.txt
RUN curl --silent -L https://github.com/bitnami/render-template/releases/download/v1.0/render-template.zip > /tmp/render-template.zip && echo "60334a29f9692659f9d3a5d9659f2a97de1f5e7a0fc2e84c1868fdba7f160a9d /tmp/render-template.zip" | sha256sum --check && unzip -q -d /usr/local/bin -o /tmp/render-template.zip render-template && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/bitnami/render-template/master/COPYING > /opt/bitnami/licenses/render-template-1.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="kafka" \
    BITNAMI_IMAGE_VERSION="2.4.0-ol-7-r21" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/kafka/bin:$PATH"

EXPOSE 9092

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
