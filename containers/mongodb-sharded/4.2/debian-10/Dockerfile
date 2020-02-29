FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpcap0.8 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "yq" "3.2.0-0" --checksum c1bed30835eb05a04c9705ad17a0763f3e7dc4558bb878611e00e4ee8e2e1ac7
RUN . ./libcomponent.sh && component_unpack "wait-for-port" "1.0.0-1" --checksum 07c4678654b01811f22b5bb65a8d6f8e253abd4524ebb3b78c7d3df042cf23bd
RUN . ./libcomponent.sh && component_unpack "render-template" "1.0.0-0" --checksum 63449e5ed4ece61d7bbeda0d173b68768d9fb444922b8ffa2e1042be20687142
RUN . ./libcomponent.sh && component_unpack "mongodb" "4.2.3-0" --checksum 32c11aa42e0b22b7a1f4fc071ff42ea9ba81d23da45eb7fda4040eb118c46c91
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mongodb-sharded" \
    BITNAMI_IMAGE_VERSION="4.2.3-debian-10-r31" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/common/bin:/opt/bitnami/common/bin:/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
