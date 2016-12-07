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

FROM gcr.io/stacksmith-images/minideb-buildpack:jessie-r5

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="npx76xt" \
    STACKSMITH_STACK_NAME="Node.js for bitnami/bitnami-docker-node" \
    STACKSMITH_STACK_PRIVATE="1"

# System packages required
RUN install_packages --no-install-recommends libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

RUN bitnami-pkg install node-7.2.0-1 --checksum 5db6e968fc6613fc9c04b8933aff9b1699d23f4755b63570ff644420fe0960ff

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH \
    NODE_PATH=/opt/bitnami/node/lib/node_modules

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

ENV BITNAMI_APP_NAME=node \
    BITNAMI_IMAGE_VERSION=7.2.0-r0

EXPOSE 3000
WORKDIR /app

CMD ["node"]
