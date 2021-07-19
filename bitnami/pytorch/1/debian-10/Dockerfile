FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.7.11-0" --checksum 332cd96e2483f4f6570c2fcb9213e0718215eec983f85eafc8931e2d30f58e49
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "pytorch" "1.9.0-1" --checksum 8d6b40252cefdeb3d92cc895965e19362892cbbb43e91c73542f829c084f8642
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/pytorch/postunpack.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.9.0-debian-10-r32" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/python/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/pytorch/entrypoint.sh" ]
CMD [ "python" ]
