FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libevent-2.1-6 libsasl2-2 libsasl2-modules procps sasl2-bin sudo unzip
RUN . ./libcomponent.sh && component_unpack "memcached" "1.6.0-1" --checksum 8c1de120a568dbd3ca2d1ebcbff17e2af4c983a1436a8870d58a15dc2271a370
RUN . ./libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root memcached

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.6.0-debian-10-r9" \
    PATH="/opt/bitnami/memcached/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
