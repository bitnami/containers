FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgomp1 libgssapi-krb5-2 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtcmalloc-minimal4 libtinfo6 libtirpc3 numactl procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-153" --checksum c33962b71ef103d071804f57720a34bada903c9a9bec1fbeddf57e97a5bd6279
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "pytorch" "1.12.0-1" --checksum 0efe58aa732e11d8a1d0d49136d4fe15856bfa8c0e9b0deb774989b4d4025820
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/pytorch/postunpack.sh
ENV APP_VERSION="1.12.0" \
    BITNAMI_APP_NAME="pytorch" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/python/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    LD_PRELOAD="/opt/bitnami/python/lib/libiomp5.so:/usr/lib/x86_64-linux-gnu/libjemalloc.so.2" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/pytorch/entrypoint.sh" ]
CMD [ "python" ]
