FROM bitnami/base-ubuntu:14.04
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=apache \
    BITNAMI_APP_USER=daemon \
    BITNAMI_APP_VERSION=2.4.12-2 \
    BITNAMI_APP_DIR=$BITNAMI_PREFIX/apache2

ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME \
    PATH=$BITNAMI_APP_DIR/bin:$PATH

RUN sh $BITNAMI_PREFIX/install.sh

EXPOSE 80 443
VOLUME ["$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs", "/app"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["httpd"]
