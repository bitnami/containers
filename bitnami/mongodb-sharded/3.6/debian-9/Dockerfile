FROM docker.io/bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 libpcap0.8 libssl1.1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "3.4.1-0" --checksum 72c0026ba4c4825e61c4d67fb291c522514600048347df8b16c0d4690f59bd7c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-1" --checksum 04cca3ba5204635108908eb8032b7b2f1882aba2f1636cc45fe3c70dfa0b498a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.0-1" --checksum 5ab8cb7ec2412c49d506087b360876bae0be39a357427fae8816536b0fd6241d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb" "3.6.23-0" --checksum 417375e1d4f5e3cdd6da91abb10d4dd5460f22c2b9d322df622807c1d8feceb4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum b14e3fcbfe88c7a7421cb2adbf523c5a68ed0624651f9809190991906b531003
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/liblog.sh /liblog.sh
RUN ln -s /opt/bitnami/scripts/mongodb-sharded/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/mongodb-sharded/postunpack.sh
ENV BITNAMI_APP_NAME="mongodb-sharded" \
    BITNAMI_IMAGE_VERSION="3.6.23-debian-9-r55" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mongodb-sharded/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mongodb-sharded/run.sh" ]
