FROM docker.io/bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpcap0.8 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libtasn1-6 libunistring0 numactl procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.12.2-0" --checksum c592c85ca37534b97c7e48fd6a16780ebd8c5dfdac6039f63f2e9bb0653a9bba
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-1" --checksum 04cca3ba5204635108908eb8032b7b2f1882aba2f1636cc45fe3c70dfa0b498a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.0-1" --checksum 5ab8cb7ec2412c49d506087b360876bae0be39a357427fae8816536b0fd6241d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb" "4.0.27-0" --checksum 95b7a05fa4c90f5483f7a93d6b937fdba16ae44b016e5e3b2db6a5b7130462c9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum d177bc3da307f83d83ac8284be8062fc8b428e8f38a3b697876b5efc73ebf74f
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mongodb/postunpack.sh
ENV BITNAMI_APP_NAME="mongodb" \
    BITNAMI_IMAGE_VERSION="4.0.27-debian-9-r3" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mongodb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mongodb/run.sh" ]
