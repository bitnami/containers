FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-1" --checksum 2ac3d5028d8f8fc44cbf4b71e948458c1ae53c12a052ae62229fd52bf14191a6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "12.22.11-0" --checksum 6e635b4dbf839d3d43cf54540081f01405710ce2fb3b313e368cd1f1d9c8847a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse-dashboard" "3.3.0-8" --checksum 3d08a9c9b1f863eff167c2be195b9ee4f5991010e59aac0aec60f6a3d10a7100
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse-dashboard/postunpack.sh
ENV APP_VERSION="3.3.0" \
    BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="3.3.0-debian-10-r78" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/parse-dashboard/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000 4040

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse-dashboard/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse-dashboard/run.sh" ]
