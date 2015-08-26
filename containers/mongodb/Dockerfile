FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongodb \
    BITNAMI_APP_VERSION=3.0.6-0

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/$BITNAMI_APP_NAME \
    BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME

ENV PATH=$BITNAMI_APP_DIR/bin:$BITNAMI_PREFIX/common/bin:$PATH


RUN sh $BITNAMI_PREFIX/install.sh --mongodb_password bitnami --disable-components common

COPY bitnami-utils-custom.sh /bitnami-utils-custom.sh
COPY entrypoint.sh /entrypoint.sh

EXPOSE 27017
VOLUME ["$BITNAMI_APP_VOL_PREFIX/data", "$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mongod"]
