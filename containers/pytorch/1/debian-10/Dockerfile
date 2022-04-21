FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgcc1 libgomp1 libjemalloc2 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtcmalloc-minimal4 libtinfo6 numactl procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.7.13-3" --checksum 3c762deccd57447e5a1f0ae9fb16a664b59739506601dc272d8735f342c6c8cf
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "pytorch" "1.11.0-0" --checksum 2c11a9a21993663ba00e8a4a03422cce9286f219aef108cf4353a8ff2eb4fc91
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/pytorch/postunpack.sh
ENV APP_VERSION="1.11.0" \
    BITNAMI_APP_NAME="pytorch" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/python/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    LD_PRELOAD="/opt/bitnami/python/lib/libiomp5.so:/usr/lib/x86_64-linux-gnu/libjemalloc.so.2" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/pytorch/entrypoint.sh" ]
CMD [ "python" ]
