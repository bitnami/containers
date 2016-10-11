## BUILDING
##   (from project root directory)
##   $ docker build -t ubuntu-for-bitnami-bitnami-docker-mariadb .
##
## RUNNING
##   $ docker run ubuntu-for-bitnami-bitnami-docker-mariadb

FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="nd6ziiq" \
    STACKSMITH_STACK_NAME="Ubuntu for bitnami/bitnami-docker-mariadb" \
    STACKSMITH_STACK_PRIVATE="1"

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating


ENV BITNAMI_IMAGE_VERSION=10.1.18-r0 \
    BITNAMI_APP_NAME=mariadb \
    BITNAMI_APP_USER=mysql

RUN bitnami-pkg unpack mariadb-10.1.18-0 --checksum 53e3a45cf69a9fde5bddd954be951a02bc49cf412b3841c4f6dbdbc69f3b6f54
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 3306

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "mariadb"]
