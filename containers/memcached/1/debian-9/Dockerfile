FROM bitnami/minideb-extras-base:stretch-r376
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libevent-2.0-5 libsasl2-2 libsasl2-modules sasl2-bin
RUN . ./libcomponent.sh && component_unpack "memcached" "1.5.19-1" --checksum e95b575469c3741112a4fea6ea2999eb1b1cbe8264d7440766a09667c1383930

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.5.19-debian-9-r13" \
    PATH="/opt/bitnami/memcached/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
