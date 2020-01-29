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
RUN . ./libcomponent.sh && component_unpack "miniconda" "4.8.1-2" --checksum 8f9abf5cf6a5fc3d6d3282ff94edee3ca3df1da252a3e72c024fd4406ffe0a25
RUN . ./libcomponent.sh && component_unpack "pytorch" "1.4.0-0" --checksum f666f1ea29d05d1574fb6db1343ba9c3039a892e5865deb21858883d3ffa1358
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.4.0-ol-7-r4" \
    LD_LIBRARY_PATH="/opt/bitnami/miniconda/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/miniconda/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
