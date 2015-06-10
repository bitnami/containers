FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV BITNAMI_PREFIX=/usr/local/bitnami
ENV BITNAMI_APP_NAME memcached
ENV BITNAMI_APP_USER memcached
ENV BITNAMI_APP_VERSION 1.4.21-1
ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME
ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/$BITNAMI_APP_NAME

ADD https://www.dropbox.com/s/9rffufx3drjisl1/install.sh?dl=1 /tmp/install.sh
ADD post-install.sh /tmp/post-install.sh

RUN stack=1 sh /tmp/install.sh

ENV PATH $BITNAMI_APP_DIR/bin:$BITNAMI_PREFIX/common/bin:$PATH

VOLUME ["$BITNAMI_APP_VOL_PREFIX/logs"]
EXPOSE 11211

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["memcached", "-v"]
