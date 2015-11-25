FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/wildfly \
    BITNAMI_APP_NAME=wildfly \
    BITNAMI_APP_USER=wildfly \
    BITNAMI_APP_DAEMON=standalone.sh|domain.sh \
    BITNAMI_APP_VERSION=9.0.1-0-r01

ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME \
    JAVA_HOME=$BITNAMI_PREFIX/java \
    JRE_HOME=$BITNAMI_PREFIX/java \
    PATH=$BITNAMI_APP_DIR/bin:$PATH

RUN $BITNAMI_PREFIX/install.sh --jboss_manager_username manager --jboss_manager_password wildfly

COPY rootfs/ /

EXPOSE 8080 9990
VOLUME ["$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs"]

ENTRYPOINT ["/entrypoint.sh"]
