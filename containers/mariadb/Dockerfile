FROM bitnami/base-ubuntu:14.04
MAINTAINER Bitnami

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/mysql
ENV BITNAMI_APP_NAME mariadb
ENV BITNAMI_APP_USER mysql
ENV BITNAMI_APP_VERSION 5.5.42-0
ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME

COPY bitnami-utils-custom.sh /bitnami-utils-custom.sh

RUN sh $BITNAMI_PREFIX/install.sh\
    --base_password bitnami --mysql_password bitnami --mysql_allow_all_remote_connections 1 --disable-components common --mysql_init_data_dir 0

ENV PATH $BITNAMI_APP_DIR/bin:$PATH
EXPOSE 3306
VOLUME ["$BITNAMI_APP_VOL_PREFIX/data", "$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld.bin"]
