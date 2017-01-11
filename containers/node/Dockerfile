## BUILDING
##   (from project root directory)
##   $ docker build -t node-js-for-bitnami-bitnami-docker-node .
##
## RUNNING
##   $ docker run -p 3000:3000 node-js-for-bitnami-bitnami-docker-node
##
## CONNECTING
##   Lookup the IP of your active docker host using:
##     $ docker-machine ip $(docker-machine active)
##   Connect to the container at DOCKER_IP:3000
##     replacing DOCKER_IP for the IP of your active docker host

FROM gcr.io/stacksmith-images/minideb-buildpack:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="npx76xt" \
    STACKSMITH_STACK_NAME="Node.js for bitnami/bitnami-docker-node" \
    STACKSMITH_STACK_PRIVATE="1"

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating


# System packages required
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

# Install node
RUN bitnami-pkg unpack node-7.4.0-0 --checksum 25efb29dd2c4e4f459197401843e91185fb2e1d9a60d0b58ad350bf1254f8b15

COPY rootfs /

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH \
    NODE_PATH=/opt/bitnami/node/lib/node_modules


ENV BITNAMI_APP_NAME=node \
    BITNAMI_IMAGE_VERSION=7.4.0-r0

EXPOSE 3000
WORKDIR /app

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["node"]
