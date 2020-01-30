FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbz2-1.0 libc6 libgcc1 libjemalloc2 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "python" "2.7.17-0" --checksum 6ff3687780ea65b542a1ce9bcc97a71d5f29c5704c6a177dbd24eb2a9ccaecfe
RUN . ./libcomponent.sh && component_unpack "java" "1.8.242-0" --checksum 3a70f3d1c3cd9bc6ec581b2a10373a2b323c0b9af40402ce8d19aeb0b3d02400
RUN . ./libcomponent.sh && component_unpack "cassandra" "3.11.5-0" --checksum 96e552463b88a2d4468305e9de75bcce4dfc44305bebfcf969d27bdf5f47692b
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN curl --silent -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 > /usr/local/bin/yq && echo 99a01ae32f0704773c72103adb7050ef5c5cad14b517a8612543821ef32d6cc9 /usr/local/bin/yq | sha256sum --check && chmod +x /usr/local/bin/yq && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/mikefarah/yq/master/LICENSE > /opt/bitnami/licenses/yq-2.4.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.5-debian-10-r6" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
