FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgcc1 libgomp1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.10.4-2" --checksum ccad1e4649c0f8f79eb007431d8fe96aa756bf1bc95c19feab7b2b4ecc1efac3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "xgboost-intel" "1.6.1-0" --checksum 1b2c434d082e3bdd570cd8508213cc5b5ec0d375a577b2974d97b204362db937
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/xgboost-intel/postunpack.sh
ENV APP_VERSION="1.6.1" \
    BITNAMI_APP_NAME="xgboost-intel" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/xgboost-intel/entrypoint.sh" ]
CMD [ "python" ]
