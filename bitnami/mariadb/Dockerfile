FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/mysql \
    BITNAMI_APP_NAME=mariadb \
    BITNAMI_APP_USER=mysql \
    BITNAMI_APP_VERSION=5.5.44-0-r02

ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME \
    PATH=$BITNAMI_APP_DIR/bin:$PATH

COPY bitnami-utils-custom.sh /bitnami-utils-custom.sh

RUN sh $BITNAMI_PREFIX/install.sh\
    --base_password bitnami --mysql_password bitnami --mysql_allow_all_remote_connections 1 --disable-components common --mysql_init_data_dir 0

EXPOSE 3306
VOLUME ["$BITNAMI_APP_VOL_PREFIX/data", "$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld.bin"]
