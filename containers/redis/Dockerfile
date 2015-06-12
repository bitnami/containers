FROM bitnami/base-ubuntu:14.04
MAINTAINER Bitnami

ENV BITNAMI_APP_NAME redis
ENV BITNAMI_APP_USER redis
ENV BITNAMI_APP_VERSION 3.0.2-0

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/$BITNAMI_APP_NAME
ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME

RUN sh $BITNAMI_PREFIX/install.sh --disable-components common --redis_enable_authentication 0

EXPOSE 6379
VOLUME ["$BITNAMI_APP_VOL_PREFIX/data", "$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs"]

ENV PATH $BITNAMI_APP_DIR/bin:$BITNAMI_PREFIX/common/bin:$PATH

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["redis-server"]
