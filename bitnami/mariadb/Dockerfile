FROM gcr.io/stacksmith-images/ubuntu:14.04-r05
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=mariadb \
    BITNAMI_APP_VERSION=10.1.12-0 \
    BITNAMI_APP_USER=mysql

ENV BITNAMI_APP_DIR=/opt/bitnami/$BITNAMI_APP_NAME \
    BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME

ENV PATH=$BITNAMI_APP_DIR/sbin:$BITNAMI_APP_DIR/bin:$PATH

RUN bitnami-pkg install base-functions-1.0.0-2 --checksum 9789082a1e01a4411198136477723288736d5ad5990403a208423b39369c8aac
RUN bitnami-pkg unpack mariadb-10.1.12-0 --checksum 98e45fb19b8087496b0be614bf5c2cf9d849f7d828984ff85e4aa941692d1d35

COPY rootfs/ /

EXPOSE 3306

VOLUME ["$BITNAMI_APP_VOL_PREFIX"]

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "mariadb"]
