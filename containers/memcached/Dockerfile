FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=memcached \
    BITNAMI_APP_USER=memcached \
    BITNAMI_APP_VERSION=1.4.21-2-r01

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/$BITNAMI_APP_NAME \
    BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME

ENV PATH=$BITNAMI_APP_DIR/bin:$BITNAMI_PREFIX/common/bin:$PATH

RUN sh $BITNAMI_PREFIX/install.sh

VOLUME ["$BITNAMI_APP_VOL_PREFIX/logs"]
EXPOSE 11211

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["memcached", "-v"]
