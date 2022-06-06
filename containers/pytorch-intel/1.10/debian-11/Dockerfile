FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgomp1 libgssapi-krb5-2 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtcmalloc-minimal4 libtinfo6 libtirpc3 numactl procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-1" --checksum 79af9dcbaa89c4047d2d24b4a4c2ae17b771fe94972734379b9e50ef3dec3442
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "pytorch-intel" "1.10.2-0" --checksum 7f15310a9dceb6e520024a4861aacb9fecf1c2b41e7e2a10dfe0acea81660ffd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/pytorch/postunpack.sh
ENV APP_VERSION="1.10.2" \
    BITNAMI_APP_NAME="pytorch-intel" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/python/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    LD_PRELOAD="/opt/bitnami/python/lib/libiomp5.so:/usr/lib/x86_64-linux-gnu/libjemalloc.so.2" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/pytorch/entrypoint.sh" ]
CMD [ "python" ]
