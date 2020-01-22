FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libgcc1 libgomp1 libquadmath0 libstdc++6 libx11-6 procps sudo unzip
RUN . ./libcomponent.sh && component_unpack "miniconda" "4.8.1-1" --checksum b7aa5615b26fa0eb1c0f0cb251dc24337460f81a231d6853f91faa8a10683311
RUN . ./libcomponent.sh && component_unpack "pytorch" "1.4.0-0" --checksum 30a892ea5229bd306acfdb49ffc9be5d73aa2036c59555ebd795f0746368e766
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.4.0-debian-9-r5" \
    LD_LIBRARY_PATH="/opt/bitnami/miniconda/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/miniconda/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
