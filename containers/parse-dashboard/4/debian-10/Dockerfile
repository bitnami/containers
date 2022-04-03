FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-2" --checksum 704fe6b545280ae027303b4ec875b495ee6da2256b3d8f877467077b0f031a60
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "12.22.11-0" --checksum 6e635b4dbf839d3d43cf54540081f01405710ce2fb3b313e368cd1f1d9c8847a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse-dashboard" "4.0.1-1" --checksum 14e95d0387c3ec305ae75fc12f52f70b7e6fb5200911378f257e0295ecc337a9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse-dashboard/postunpack.sh
ENV APP_VERSION="4.0.1" \
    BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="4.0.1-debian-10-r14" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/parse-dashboard/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000 4040

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse-dashboard/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse-dashboard/run.sh" ]
