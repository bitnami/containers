FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libX11 libaio-devel libgcc libgomp libquadmath libstdc++ nss-softokn-freebl procps-ng sudo tar which
RUN . ./libcomponent.sh && component_unpack "miniconda" "4.7.12-0" --checksum b8d9f716b8a4c41953286b1a9a07638c5adc02922a6735260b0a899ba6315980
RUN . ./libcomponent.sh && component_unpack "pytorch" "1.3.1-0" --checksum a9e5866ab3268c104f791d4351b0d6aaf54d5a980941ab3943a2abd0236ea39a
RUN yum upgrade -y && \
    rm -r /var/cache/yum

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.3.1-ol-7-r57" \
    LD_LIBRARY_PATH="/opt/bitnami/miniconda/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/miniconda/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
