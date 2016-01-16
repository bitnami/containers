FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/postgresql \
    BITNAMI_APP_NAME=postgresql \
    BITNAMI_APP_DAEMON=postgres \
    BITNAMI_APP_USER=postgres \
    BITNAMI_APP_VERSION=9.4.5-2-r01

ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME \
    PATH=$BITNAMI_APP_DIR/bin:$PATH

RUN $BITNAMI_PREFIX/install.sh\
    --postgres_password bitnami

COPY rootfs/ /

EXPOSE 5432
VOLUME ["$BITNAMI_APP_VOL_PREFIX/data", "$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs"]
ENTRYPOINT ["/entrypoint.sh"]
