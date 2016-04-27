FROM bitnami/base-ubuntu:14.04-buildpack-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=node \
    BITNAMI_APP_USER=bitnami \
    BITNAMI_APP_VERSION=6.0.0-0 \
    BITNAMI_APP_DIR=$BITNAMI_PREFIX/nodejs

ENV PATH=$BITNAMI_PREFIX/python/bin:$BITNAMI_APP_DIR/bin:$BITNAMI_PREFIX/common/bin:$PATH

RUN $BITNAMI_PREFIX/install.sh

USER $BITNAMI_APP_USER
WORKDIR /app

EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]
CMD ["node"]
