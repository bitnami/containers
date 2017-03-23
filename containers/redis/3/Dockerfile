FROM bitnami/minideb-extras:jessie-r13
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.2.8-r2 \
    BITNAMI_APP_NAME=redis \
    PATH=/opt/bitnami/redis/bin:$PATH

ENV GOSU_VERSION=1.10 \
    GOSU_GPG_KEY=B42F6819007F00F88E364FD4036A9C25BF357DD4

# System packages required
RUN install_packages libc6

# Install redis
RUN bitnami-pkg unpack redis-3.2.8-0 --checksum 2dcd69c0bbcb6e2ab82975d39ee32c2795c612e85012d599d36553c4f5ab8f3d

# Install gosu
RUN cd /tmp && \
  gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys $GOSU_GPG_KEY && \
  gpg --fingerprint $GOSU_GPG_KEY | grep -q "Key fingerprint = B42F 6819 007F 00F8 8E36  4FD4 036A 9C25 BF35 7DD4" && \
  curl -sSL https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc -o gosu.asc && \
  curl -sSL https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64 -o /usr/local/bin/gosu && \
  gpg --verify gosu.asc /usr/local/bin/gosu && \
  chmod +x /usr/local/bin/gosu && \
  rm gosu.asc

COPY rootfs /

ENV REDIS_PASSWORD= \
    REDIS_REPLICATION_MODE= \
    REDIS_MASTER_HOST= \
    REDIS_MASTER_PORT=6379 \
    REDIS_MASTER_PASSWORD=

VOLUME ["/bitnami/redis"]

EXPOSE 6379

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/run.sh"]
