FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=nodejs \
    BITNAMI_APP_USER=bitnami \
    BITNAMI_APP_VERSION=0.12.4-1-r01 \
    BITNAMI_APP_DIR=$BITNAMI_PREFIX/nodejs \
    PATH=$BITNAMI_PREFIX/python/bin:$BITNAMI_PREFIX/nodejs/bin:$BITNAMI_PREFIX/common/bin:$PATH

RUN sh $BITNAMI_PREFIX/install.sh

USER $BITNAMI_APP_USER

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3000
VOLUME ["/app"]
WORKDIR /app

CMD ["node"]
