FROM bitnami/oraclelinux-extras-base:7-r431
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc libX11 libgcc libgomp libquadmath libstdc++ nss-softokn-freebl
RUN . ./libcomponent.sh && component_unpack "miniconda" "4.7.10-0" --checksum a4f2686a75ba4a0ccb19c74f3bb841fc0d1fd9a4c7269a86318498b5b038c946
RUN . ./libcomponent.sh && component_unpack "pytorch" "1.2.0-0" --checksum 63a45524e245914bccffa6790fcba4666f92c82abc4b18c1c46f4d944aeb8b4e

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.2.0-ol-7-r54" \
    LD_LIBRARY_PATH="/opt/bitnami/miniconda/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/miniconda/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
