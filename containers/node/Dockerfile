FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV BITNAMI_PREFIX /usr/local/bitnami
ENV BITNAMI_APP_NAME nodejs
ENV BITNAMI_APP_VERSION 0.12.4-0
ENV BITNAMI_APP_DIR $BITNAMI_PREFIX/nodejs
ENV BITNAMI_APP_USER bitnami

ADD https://www.dropbox.com/s/9rffufx3drjisl1/install.sh?dl=1 /tmp/install.sh
ADD post-install.sh /tmp/post-install.sh
RUN sh /tmp/install.sh

ENV PATH $BITNAMI_PREFIX/python/bin:$BITNAMI_PREFIX/nodejs/bin:$BITNAMI_PREFIX/common/bin:$PATH
USER $BITNAMI_APP_USER

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3000
VOLUME ["/app"]
WORKDIR /app

CMD ["node"]
