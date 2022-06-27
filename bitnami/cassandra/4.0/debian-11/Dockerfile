FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libtinfo6 libtirpc3 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.9.13-151" --checksum c714c01604cf2e8a41ed7432446f38fe16cd02aee371468dfe074b5eaac9bb2b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.333-150" --checksum 02a91d298bbe3bb5d240f635802a50b2970b19eba960c1804b7275f88a944bb3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-150" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.25.3-0" --checksum a937d298205d3f7e8fcaa3ddbd24934cb2b809bcea54a1c0b3e3f29aa61428ac
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "cassandra" "4.0.4-150" --checksum 8685c6860b94c2611ea3fc275d864d93d432a59d5ab5d0a17a62705a5a158d8f
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/cassandra/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/cassandra/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/cassandra/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="4.0.4" \
    BITNAMI_APP_NAME="cassandra" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 7000 9042

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/cassandra/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/cassandra/run.sh" ]
