FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libgcc libpcap libselinux openssl-libs pcre procps-ng sudo tar unzip which zlib
RUN . ./libcomponent.sh && component_unpack "mongodb" "3.6.17-0" --checksum ac45f6006831e81a8a9630b3363c913558c9626ac6111f3f77f1dc7e7dfacc3c
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN curl --silent -L https://github.com/bitnami/render-template/releases/download/v1.0/render-template.zip > /tmp/render-template.zip && echo "60334a29f9692659f9d3a5d9659f2a97de1f5e7a0fc2e84c1868fdba7f160a9d /tmp/render-template.zip" | sha256sum --check && unzip -q -d /usr/local/bin -o /tmp/render-template.zip render-template && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/bitnami/render-template/master/COPYING > /opt/bitnami/licenses/render-template-1.0.txt
RUN curl --silent -L https://github.com/bitnami/wait-for-port/releases/download/v1.0/wait-for-port.zip > /tmp/wait-for-port.zip && \
    echo "8d26181f4629211b70db4f96236616056b1ed8e5920d8023f7c883071e76c1ed /tmp/wait-for-port.zip" | sha256sum --check && \
    unzip -q -d /usr/local/bin -o /tmp/wait-for-port.zip wait-for-port && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/bitnami/wait-for-port/master/COPYING > /opt/bitnami/licenses/wait-for-port-1.0.txt
RUN curl --silent -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 > /usr/local/bin/yq && echo 99a01ae32f0704773c72103adb7050ef5c5cad14b517a8612543821ef32d6cc9 /usr/local/bin/yq | sha256sum --check && chmod +x /usr/local/bin/yq && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/mikefarah/yq/master/LICENSE > /opt/bitnami/licenses/yq-2.4.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mongodb-sharded" \
    BITNAMI_IMAGE_VERSION="3.6.17-ol-7-r7" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
