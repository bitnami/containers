FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl cyrus-sasl-lib expat glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libnghttp2 libselinux nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre procps-ng sudo tar unzip which zlib
RUN . ./libcomponent.sh && component_unpack "apache" "2.4.41-3" --checksum 30ae9f98466bc180ec5b3121b000e0a8ee36ee3434d4645c7c3aa22710cc6166
RUN curl --silent -L https://github.com/bitnami/render-template/releases/download/v1.0/render-template.zip > /tmp/render-template.zip && echo "60334a29f9692659f9d3a5d9659f2a97de1f5e7a0fc2e84c1868fdba7f160a9d /tmp/render-template.zip" | sha256sum --check && unzip -q -d /usr/local/bin -o /tmp/render-template.zip render-template && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/bitnami/render-template/master/COPYING > /opt/bitnami/licenses/render-template-1.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="apache" \
    BITNAMI_IMAGE_VERSION="2.4.41-ol-7-r115" \
    PATH="/opt/bitnami/apache/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
