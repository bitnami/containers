FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-152" --checksum a831df58c181297ce77597daf2364175cbb9f211f7755ca8d8c8b5918ad9ce24
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.20.0-0" --checksum 4580c44a68dab8200beed1d6c1a2397c854722ada2b81d9564b20388336453f9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb-shell" "1.5.0-151" --checksum d01f90cda1a2fbef6261c73cd7486c9ba0999ea5ee33ec457711127466e5af56
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse" "5.2.4-0" --checksum d3bbfb7a1f9b61846da1ca5fdee8b91d789279a0c1b7a52373264dd6712a4a4b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse/postunpack.sh
ENV APP_VERSION="5.2.4" \
    BITNAMI_APP_NAME="parse" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 1337 3000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse/run.sh" ]
