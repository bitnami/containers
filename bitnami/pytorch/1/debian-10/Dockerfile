FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libgcc1 libgomp1 libquadmath0 libstdc++6 libx11-6 procps sudo unzip
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "miniconda" "4.8.2-1" --checksum 5dce1e477a472f641fca2e5fbe9baa1af0e2b94b439da80c4bc7246bc74c097e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "pytorch" "1.5.0-0" --checksum 336de1a99da4e19e71569f5894e9dacaf6994522a4d1789a4f32046bfba24984
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/pytorch/postunpack.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.5.0-debian-10-r18" \
    LD_LIBRARY_PATH="/opt/bitnami/miniconda/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/miniconda/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/miniconda/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/pytorch/entrypoint.sh" ]
CMD [ "python" ]
