FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "11.0.6-0" --checksum f7446f8bec72b6b2606d37ba917accc243e6cd4e722700c39ef83832c46fb0c6
RUN . ./libcomponent.sh && component_unpack "kafka" "2.4.0-0" --checksum cb923a585b78ab43ea458e03d2b6f9289b00e97b05173255357a26dc5113a205
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN curl --silent -L https://github.com/bitnami/render-template/releases/download/v1.0/render-template.zip > /tmp/render-template.zip && echo "60334a29f9692659f9d3a5d9659f2a97de1f5e7a0fc2e84c1868fdba7f160a9d /tmp/render-template.zip" | sha256sum --check && unzip -q -d /usr/local/bin -o /tmp/render-template.zip render-template && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/bitnami/render-template/master/COPYING > /opt/bitnami/licenses/render-template-1.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="kafka" \
    BITNAMI_IMAGE_VERSION="2.4.0-debian-10-r30" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/kafka/bin:$PATH"

EXPOSE 9092

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
