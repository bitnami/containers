FROM gcr.io/stacksmith-images/minideb:jessie-r10
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.4.2-r1 \
    BITNAMI_APP_NAME=mongodb \
    PATH=/opt/bitnami/mongodb/bin:$PATH

ENV GOSU_VERSION=1.10 \
    GOSU_GPG_KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4

# System packages required
RUN install_packages libssl1.0.0 libc6 libgcc1 libpcap0.8

# Install mongodb
RUN bitnami-pkg unpack mongodb-3.4.2-0 --checksum 0a8221d11312a3dc909010b0c4aa171adc2dd3b3d0ed50b240f629c3deb127c9

# Install gosu
RUN cd /tmp && \
  gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys $GOSU_GPG_KEY && \
  gpg --fingerprint $GOSU_GPG_KEY | grep -q "Key fingerprint = B42F 6819 007F 00F8 8E36  4FD4 036A 9C25 BF35 7DD4" && \
  curl -sSL https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc -o gosu.asc && \
  curl -sSL https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64 -o /usr/local/bin/gosu && \
  gpg --verify gosu.asc /usr/local/bin/gosu && \
  chmod +x /usr/local/bin/gosu && \
  rm gosu.asc

COPY rootfs/ /

ENV MONGODB_ROOT_PASSWORD= \
    MONGODB_USERNAME= \
    MONGODB_PASSWORD= \
    MONGODB_DATABASE= \
    MONGODB_REPLICA_SET_MODE= \
    MONGODB_REPLICA_SET_NAME= \
    MONGODB_REPLICA_SET_KEY= \
    MONGODB_PRIMARY_HOST= \
    MONGODB_PRIMARY_PORT=27017 \
    MONGODB_PRIMARY_ROOT_USER=root \
    MONGODB_PRIMARY_ROOT_PASSWORD=

VOLUME ["/bitnami/mongodb"]

EXPOSE 27017

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/run.sh"]
