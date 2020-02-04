FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libevent-2.1-6 libsasl2-2 libsasl2-modules procps sasl2-bin sudo unzip
RUN . ./libcomponent.sh && component_unpack "memcached" "1.5.22-0" --checksum 8653e4837f04481a6a64a5d06f65e401de413343075c5241c32ccd3b6307ce2f
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.5.22-debian-10-r2" \
    PATH="/opt/bitnami/memcached/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
