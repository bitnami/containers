FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV BITNAMI_PREFIX /usr/local/bitnami
ENV BITNAMI_APP_DIR $BITNAMI_PREFIX/nginx
ENV BITNAMI_APP_NAME nginxstandalone
ENV BITNAMI_APP_VERSION 1.8.0-0
ENV BITNAMI_APP_VOL_PREFIX /bitnami/nginx
ENV BITNAMI_APP_USER daemon

ADD https://www.dropbox.com/s/9rffufx3drjisl1/install.sh?dl=1 /tmp/install.sh
ADD post-install.sh /tmp/post-install.sh

RUN sh /tmp/install.sh

ADD vhosts/* $BITNAMI_APP_DIR/conf.defaults/vhosts/

ENV PATH $BITNAMI_APP_DIR/sbin:$BITNAMI_PREFIX/common/bin:$PATH

EXPOSE 80 443
VOLUME ["$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs", "/app"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
