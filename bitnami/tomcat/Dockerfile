FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/apache-tomcat \
    BITNAMI_APP_NAME=tomcat \
    BITNAMI_APP_USER=tomcat \
    BITNAMI_APP_VERSION=7.0.63-0

ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME \
    PATH=$BITNAMI_APP_DIR/bin:$PATH

RUN sh $BITNAMI_PREFIX/install.sh\
    --tomcat_manager_username manager

COPY bitnami-utils-custom.sh /bitnami-utils-custom.sh
EXPOSE 8080
VOLUME ["$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs", "$BITNAMI_APP_VOL_PREFIX/webapps"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["catalina.sh", "run"]
