FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio-devel libgcc libicu libstdc++ ncurses-libs openssl-libs procps-ng sudo tar unzip which zlib
RUN . ./libcomponent.sh && component_unpack "couchdb" "2.3.1-5" --checksum 5ba614026391bc3a4d2748531d76ccdd365e32f0befae99e059c816ff88a834b
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN curl --silent -Lo /tmp/ini-file.zip https://github.com/bitnami/ini-file/releases/download/v1.0/ini-file.zip && echo 2f12cc487b0b17cf5346326ae653951e9ff6d5eb6d3c9217c602060778996b64 /tmp/ini-file.zip | sha256sum --check && unzip -q -d /usr/local/bin -o /tmp/ini-file.zip ini-file && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/bitnami/ini-file/master/COPYING > /opt/bitnami/licenses/ini-file-1.0.txt
RUN curl --silent -L https://github.com/bitnami/wait-for-port/releases/download/v1.0/wait-for-port.zip > /tmp/wait-for-port.zip && \
    echo "8d26181f4629211b70db4f96236616056b1ed8e5920d8023f7c883071e76c1ed /tmp/wait-for-port.zip" | sha256sum --check && \
    unzip -q -d /usr/local/bin -o /tmp/wait-for-port.zip wait-for-port && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/bitnami/wait-for-port/master/COPYING > /opt/bitnami/licenses/wait-for-port-1.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="couchdb" \
    BITNAMI_IMAGE_VERSION="2.3.1-ol-7-r138" \
    LD_LIBRARY_PATH="/opt/bitnami/common/lib:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/couchdb/bin:$PATH"

VOLUME [ "/bitnami/couchdb" ]

EXPOSE 5984 4369 9100

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
