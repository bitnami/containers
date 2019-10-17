FROM bitnami/oraclelinux-extras-base:7-r450
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc libX11 libgcc libgomp libquadmath libstdc++ nss-softokn-freebl
RUN . ./libcomponent.sh && component_unpack "miniconda" "4.7.12-0" --checksum b8d9f716b8a4c41953286b1a9a07638c5adc02922a6735260b0a899ba6315980
RUN . ./libcomponent.sh && component_unpack "pytorch" "1.3.0-0" --checksum 1faad1c85fe47a81b1204994bd767a75d0412af233e13739dafc8581b982ad6b

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.3.0-ol-7-r7" \
    LD_LIBRARY_PATH="/opt/bitnami/miniconda/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/miniconda/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
