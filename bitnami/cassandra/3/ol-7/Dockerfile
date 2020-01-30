FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl glibc gzip hostname jemalloc keyutils-libs krb5-libs libaio-devel libcom_err libgcc libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre procps-ng readline sqlite sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "python" "2.7.17-1" --checksum 764d5a1d70462980aedd371c7062c517055dabcb386805cc7c7d208219633ad7
RUN . ./libcomponent.sh && component_unpack "java" "1.8.242-0" --checksum 974f750091ac1bf18cc1ce9472ef5ed7c1b328a2c17471cb9ac810fcded67151
RUN . ./libcomponent.sh && component_unpack "cassandra" "3.11.5-1" --checksum 98b8d3d7424deed8f2b8597998b784e2f223b3262e47a857912f7f0e83279fec
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN curl --silent -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 > /usr/local/bin/yq && echo 99a01ae32f0704773c72103adb7050ef5c5cad14b517a8612543821ef32d6cc9 /usr/local/bin/yq | sha256sum --check && chmod +x /usr/local/bin/yq && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/mikefarah/yq/master/LICENSE > /opt/bitnami/licenses/yq-2.4.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.5-ol-7-r93" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 9042 7000

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
