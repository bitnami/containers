FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/wildfly \
    BITNAMI_APP_NAME=wildfly \
    BITNAMI_APP_USER=wildfly \
    BITNAMI_APP_VERSION=9.0.1-0

ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME \
    JAVA_HOME=$BITNAMI_PREFIX/java \
    JRE_HOME=$BITNAMI_PREFIX/java \
    PATH=$BITNAMI_APP_DIR/bin:$PATH

RUN sh $BITNAMI_PREFIX/install.sh\
    --jboss_manager_username manager --jboss_manager_password wildfly

COPY bitnami-utils-custom.sh /bitnami-utils-custom.sh
EXPOSE 8080 8443 8009 9990 9443 9999
VOLUME ["$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs", "/app"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["standalone.sh", "-Dwildfly.as.deployment.ondemand=false"]
