FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/apache-tomcat \
    BITNAMI_APP_NAME=tomcat \
    BITNAMI_APP_USER=tomcat \
    BITNAMI_APP_DAEMON=catalina.sh \
    BITNAMI_APP_VERSION=7.0.65-1

ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME \
    PATH=$BITNAMI_APP_DIR/bin:$PATH

RUN $BITNAMI_PREFIX/install.sh --tomcat_manager_username manager

COPY rootfs/ /

EXPOSE 8080
VOLUME ["$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs"]

ENTRYPOINT ["/entrypoint.sh"]
