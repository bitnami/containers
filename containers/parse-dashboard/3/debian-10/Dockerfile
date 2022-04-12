FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-3" --checksum a328c8fb3db9e60d3aa19eb7ca31de5da372affcb3d7c0d73610b4a19b634f94
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "12.22.12-0" --checksum e6f0dde4e32f51a83d49be415c8b4f5d92030b6dc1446f225273f7a1dba08a24
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse-dashboard" "3.3.0-8" --checksum 3d08a9c9b1f863eff167c2be195b9ee4f5991010e59aac0aec60f6a3d10a7100
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse-dashboard/postunpack.sh
ENV APP_VERSION="3.3.0" \
    BITNAMI_APP_NAME="parse-dashboard" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/parse-dashboard/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000 4040

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse-dashboard/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse-dashboard/run.sh" ]
