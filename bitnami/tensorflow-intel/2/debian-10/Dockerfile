FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.9.12-1" --checksum adb7d70d8080d38dab0ca6f1b0d7efce772b168621b6edcc4c65009c740f9b5e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tensorflow-intel" "2.8.0-1" --checksum 032632f7a59b3d244ee28ee81687507e56b6a6151cb4b1e1e9c993be70bdbc29
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/tensorflow-intel/postunpack.sh
ENV APP_VERSION="2.8.0" \
    BITNAMI_APP_NAME="tensorflow-intel" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/tensorflow-intel/entrypoint.sh" ]
CMD [ "python" ]
