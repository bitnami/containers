FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip
RUN . ./libcomponent.sh && component_unpack "harbor-core" "1.10.0-0" --checksum 7683e1482b219200a7bc2612308d434c465f4344846098e0600affe9e2bd402d
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN curl --silent -Lo /tmp/ini-file.zip https://github.com/bitnami/ini-file/releases/download/v1.0/ini-file.zip && echo 2f12cc487b0b17cf5346326ae653951e9ff6d5eb6d3c9217c602060778996b64 /tmp/ini-file.zip | sha256sum --check && unzip -q -d /usr/local/bin -o /tmp/ini-file.zip ini-file && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/bitnami/ini-file/master/COPYING > /opt/bitnami/licenses/ini-file-1.0.txt
RUN curl --silent -L https://github.com/bitnami/wait-for-port/releases/download/v1.0/wait-for-port.zip > /tmp/wait-for-port.zip && \
    echo "8d26181f4629211b70db4f96236616056b1ed8e5920d8023f7c883071e76c1ed /tmp/wait-for-port.zip" | sha256sum --check && \
    unzip -q -d /usr/local/bin -o /tmp/wait-for-port.zip wait-for-port && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/bitnami/wait-for-port/master/COPYING > /opt/bitnami/licenses/wait-for-port-1.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-core" \
    BITNAMI_IMAGE_VERSION="1.10.0-debian-10-r8" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-core/bin:$PATH"

VOLUME [ "/etc/core", "/data" ]

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-core
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "harbor_core" ]
