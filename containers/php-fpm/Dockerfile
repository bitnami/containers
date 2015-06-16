FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=phpfpm \
    BITNAMI_APP_USER=bitnami \
    BITNAMI_APP_VERSION=5.5.26-2-r01 \
    BITNAMI_APP_DIR=$BITNAMI_PREFIX/php

ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME \
    PATH=$BITNAMI_APP_DIR/sbin:$BITNAMI_APP_DIR/bin:$BITNAMI_PREFIX/common/bin:$PATH

RUN sh $BITNAMI_PREFIX/install.sh\
    --php_fpm_allow_all_remote_connections 1 --php_fpm_connection_mode port

USER $BITNAMI_APP_USER

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
VOLUME ["/app", "$BITNAMI_APP_VOL_PREFIX/logs", "$BITNAMI_APP_VOL_PREFIX/conf"]
WORKDIR /app

CMD ["php-fpm", "-F"]
