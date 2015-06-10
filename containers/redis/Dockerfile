FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV BITNAMI_PREFIX=/usr/local/bitnami
ENV BITNAMI_APP_NAME redis
ENV BITNAMI_APP_USER redis
ENV BITNAMI_APP_VERSION 3.0.2-0

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/$BITNAMI_APP_NAME
ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME

ADD https://www.dropbox.com/s/9rffufx3drjisl1/install.sh?dl=1 /tmp/install.sh
ADD post-install.sh /tmp/post-install.sh

RUN sh /tmp/install.sh --disable-components common --redis_enable_authentication 0

EXPOSE 6379
VOLUME ["$BITNAMI_APP_VOL_PREFIX/data", "$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs"]

ENV PATH $BITNAMI_APP_DIR/bin:$BITNAMI_PREFIX/common/bin:$PATH

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["redis-server"]
