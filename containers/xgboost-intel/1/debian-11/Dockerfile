FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgomp1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.10.5-150" --checksum ab83304d6c47f91ce2b41a01d2892a8a99ecce948615fb329ee3de0b3a6792b9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "xgboost-intel" "1.6.1-150" --checksum e099b325768c32ac0a55f93166843f7ebec13f637d799b6551f49aff400ed772
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-150" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.local && chmod g+rwX /.local

COPY rootfs /
RUN /opt/bitnami/scripts/xgboost-intel/postunpack.sh
ENV APP_VERSION="1.6.1" \
    BITNAMI_APP_NAME="xgboost-intel" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/xgboost-intel/entrypoint.sh" ]
CMD [ "python" ]
