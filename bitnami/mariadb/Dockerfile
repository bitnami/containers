FROM bitnami/base-ubuntu:14.04-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/mysql \
    BITNAMI_APP_NAME=mariadb \
    BITNAMI_APP_USER=mysql \
    BITNAMI_APP_VERSION=5.5.45-0-r01

ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME \
    PATH=$BITNAMI_APP_DIR/bin:$PATH

RUN $BITNAMI_PREFIX/install.sh\
    --base_password bitnami --mysql_password bitnami --mysql_allow_all_remote_connections 1 --disable-components common --mysql_init_data_dir 0

COPY rootfs/ /

EXPOSE 3306
VOLUME ["$BITNAMI_APP_VOL_PREFIX/data", "$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs"]
ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld.bin"]
