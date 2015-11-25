FROM bitnami/base-ubuntu:14.04-buildpack-onbuild
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=ruby \
    BITNAMI_APP_VERSION=2.2.3-1-r01 \
    BITNAMI_APP_DIR=$BITNAMI_PREFIX/ruby \
    BITNAMI_APP_USER=bitnami
ENV PATH $BITNAMI_APP_DIR/bin:$BITNAMI_PREFIX/common/bin:$PATH

RUN $BITNAMI_PREFIX/install.sh

USER $BITNAMI_APP_USER

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3000
WORKDIR /app

CMD ["irb"]
