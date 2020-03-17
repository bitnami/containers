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
RUN . ./libcomponent.sh && component_unpack "yq" "3.2.1-0" --checksum b35ff01573930f11065a5aaa23e64fbb93b545c07fb6d7a1386c61e5b6146791
RUN . ./libcomponent.sh && component_unpack "harbor-registryctl" "1.10.1-0" --checksum 80926b36e864de6028c237a3829893a0d3222da5354f0fb7fc43b434faf3d879
RUN . ./libcomponent.sh && component_unpack "harbor-registry" "1.10.1-0" --checksum d34eecf91c58a4b2bd120e7f59eb68002ef10661939d236b8d14bc9c38b6d84e
RUN . ./libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root harbor-registryctl

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registryctl" \
    BITNAMI_IMAGE_VERSION="1.10.1-debian-10-r32" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/harbor-registryctl/bin:/opt/bitnami/harbor-registry/bin:/opt/bitnami/common/bin:$PATH"

VOLUME [ "/etc/registry", "/etc/registryctl", "/storage", "/var/lib/registry" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
