FROM bitnami/oraclelinux-extras-base:7-r278
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc libX11 libgcc libgomp libquadmath libstdc++ nss-softokn-freebl
RUN . ./libcomponent.sh && component_unpack "miniconda" "4.6.14-0" --checksum 724466b0f6f3f3c928346e2b7c540a5bf2bc18756c8e1124f85c7fba788d58fc
RUN . ./libcomponent.sh && component_unpack "pytorch" "1.1.0-1" --checksum 775792c84552bf5b05b4ceb2128ea5ddbadc7d2308058e48a36476195d1331b2

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.1.0-ol-7-r8" \
    LD_LIBRARY_PATH="/opt/bitnami/miniconda/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/miniconda/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
