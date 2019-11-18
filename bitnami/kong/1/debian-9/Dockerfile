FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libpcre3 libssl1.1 libyaml-0-2 perl zlib1g
RUN . ./libcomponent.sh && component_unpack "kong" "1.4.0-0" --checksum 51463b1e46c74b195cee4474801afa93aef5f116b5b9229240f1580bc1bbbb0e

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="kong" \
    BITNAMI_IMAGE_VERSION="1.4.0-debian-9-r20" \
    PATH="/opt/bitnami/kong/bin:/opt/bitnami/kong/openresty/bin:/opt/bitnami/kong/openresty/luajit/bin:/opt/bitnami/kong/openresty/nginx/sbin:$PATH"

EXPOSE 8000 8001 8443 8444

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
