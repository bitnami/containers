FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=apache \
    BITNAMI_APP_USER=daemon \
    BITNAMI_APP_VERSION=2.4.12-4 \
    BITNAMI_APP_DIR=$BITNAMI_PREFIX/apache2

ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME \
    PATH=$BITNAMI_APP_DIR/bin:$PATH

RUN sh $BITNAMI_PREFIX/install.sh
COPY rootfs/ /

EXPOSE 80 443
VOLUME ["$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs", "/app"]
ENTRYPOINT ["/init"]
