FROM bitnami/oraclelinux-extras-base:7-r367
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc libX11 libgcc libgomp libquadmath libstdc++ nss-softokn-freebl
RUN . ./libcomponent.sh && component_unpack "miniconda" "4.7.10-0" --checksum a4f2686a75ba4a0ccb19c74f3bb841fc0d1fd9a4c7269a86318498b5b038c946
RUN . ./libcomponent.sh && component_unpack "pytorch" "1.1.0-2" --checksum 1d15f80b3499ac9a5a3a272238128ad5d65e0c8828b172c1d7447c5818e267cb

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.1.0-ol-7-r98" \
    LD_LIBRARY_PATH="/opt/bitnami/miniconda/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/miniconda/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
