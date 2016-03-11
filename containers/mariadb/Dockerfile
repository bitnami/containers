FROM gcr.io/stacksmith-images/ubuntu:14.04
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=mariadb \
    BITNAMI_APP_USER=mysql \
    BITNAMI_APP_VERSION=10.1.11-0 \
    MARIADB_PACKAGE_SHA256="59cb45e66e7b9b3697296cca8ad8c988ddc089016fef94b7133587cb838c8505"

ENV BITNAMI_APP_DIR=/opt/bitnami/$BITNAMI_APP_NAME \
    BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME

ENV PATH=$BITNAMI_APP_DIR/sbin:$BITNAMI_APP_DIR/bin:$PATH

RUN bitnami-pkg unpack $BITNAMI_APP_NAME-$BITNAMI_APP_VERSION

# these symlinks should be setup by harpoon at unpack
RUN mkdir -p $BITNAMI_APP_VOL_PREFIX && \
    ln -s $BITNAMI_APP_DIR/data $BITNAMI_APP_VOL_PREFIX/data && \
    ln -s $BITNAMI_APP_DIR/conf $BITNAMI_APP_VOL_PREFIX/conf && \
    ln -s $BITNAMI_APP_DIR/logs $BITNAMI_APP_VOL_PREFIX/logs

# temporary fix for mysql client
RUN mkdir $BITNAMI_APP_DIR/var && \
    ln -sf $BITNAMI_APP_DIR/tmp $BITNAMI_APP_DIR/var/mysql

COPY rootfs/ /

EXPOSE 3306

VOLUME ["$BITNAMI_APP_VOL_PREFIX/data"]

ENTRYPOINT ["/entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "mariadb"]
