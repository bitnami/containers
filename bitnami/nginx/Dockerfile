FROM bitnami/base-ubuntu:14.04
MAINTAINER Bitnami

ENV BITNAMI_APP_NAME nginx
ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/$BITNAMI_APP_NAME
ENV BITNAMI_APP_VERSION 1.8.0-1
ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME
ENV BITNAMI_APP_USER daemon

RUN sh $BITNAMI_PREFIX/install.sh

COPY vhosts/* $BITNAMI_APP_DIR/conf.defaults/vhosts/

ENV PATH $BITNAMI_APP_DIR/sbin:$BITNAMI_PREFIX/common/bin:$PATH

EXPOSE 80 443
VOLUME ["$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs", "/app"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
