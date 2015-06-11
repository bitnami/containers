FROM ubuntu-debootstrap:latest
MAINTAINER Bitnami

ENV BITNAMI_PREFIX /usr/local/bitnami
ENV BITNAMI_APP_NAME phpfpm
ENV BITNAMI_APP_VERSION 5.5.25-0
ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/php
ENV BITNAMI_APP_USER bitnami


COPY installer.run.sha256 /tmp/installer.run.sha256
ADD https://www.dropbox.com/s/9rffufx3drjisl1/install.sh?dl=1 /tmp/install.sh
COPY post-install.sh /tmp/post-install.sh

RUN sh /tmp/install.sh\
    --php_fpm_allow_all_remote_connections 1 --php_fpm_connection_mode port

ENV PATH $BITNAMI_APP_DIR/sbin:$BITNAMI_APP_DIR/bin:$BITNAMI_PREFIX/common/bin:$PATH
USER $BITNAMI_APP_USER

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
VOLUME ["/app"]
WORKDIR /app

CMD ["php-fpm", "-F"]
