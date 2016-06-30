## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami-bitnami-docker-laravel .
##
## RUNNING
##   $ docker run -p 9000:9000 bitnami-bitnami-docker-laravel
##
## CONNECTING
##   Lookup the IP of your active docker host using:
##     $ docker-machine ip $(docker-machine active)
##   Connect to the container at DOCKER_IP:9000
##     replacing DOCKER_IP for the IP of your active docker host

FROM gcr.io/stacksmith-images/ubuntu:14.04-r07

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="top24h8" \
    STACKSMITH_STACK_NAME="bitnami/bitnami-docker-laravel" \
    STACKSMITH_STACK_PRIVATE="1"

RUN bitnami-pkg install node-6.2.1-0 --checksum f38ccc063ccc74ab095ddcb5bd227c0722e348f53e31652fd2840779be9e581f
RUN bitnami-pkg install php-5.6.22-0 --checksum 2439cf0adfc7cc21f15a6136059883e749958af83a082108e63a80ff3c5290c0

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH
ENV PATH=/opt/bitnami/php/sbin:/opt/bitnami/php/bin:/opt/bitnami/common/bin:~/.composer/vendor/bin:$PATH
ENV NODE_PATH=/opt/bitnami/node/lib/node_modules

RUN npm install -g gulp

USER bitnami

RUN mkdir /tmp/app && cd /tmp/app && composer create-project "laravel/laravel=5.2.31" /tmp/app --prefer-dist

ENV BITNAMI_APP_NAME=laravel
ENV BITNAMI_IMAGE_VERSION=5.2.31-r4

WORKDIR /app
EXPOSE 3000

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=3000"]
