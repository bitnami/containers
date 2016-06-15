## BUILDING
##   (from project root directory)
##   $ docker build -t bitnami-bitnami-docker-express .
##
## RUNNING
##   $ docker run -p 3000:3000 bitnami-bitnami-docker-express
##
## CONNECTING
##   Lookup the IP of your active docker host using:
##     $ docker-machine ip $(docker-machine active)
##   Connect to the container at DOCKER_IP:3000
##     replacing DOCKER_IP for the IP of your active docker host

FROM gcr.io/stacksmith-images/ubuntu-buildpack:14.04-r07

MAINTAINER Bitnami <containers@bitnami.com>

ENV STACKSMITH_STACK_ID="ur4qay6" \
    STACKSMITH_STACK_NAME="bitnami/bitnami-docker-express" \
    STACKSMITH_STACK_PRIVATE="1"

RUN bitnami-pkg install node-6.2.1-0 --checksum f38ccc063ccc74ab095ddcb5bd227c0722e348f53e31652fd2840779be9e581f

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH \
    NODE_PATH=/opt/bitnami/node/lib/node_modules

## STACKSMITH-END: Modifications below this line will be unchanged when regenerating

# ExpressJS template
ENV BITNAMI_APP_NAME=express
ENV BITNAMI_IMAGE_VERSION=4.13.4-r0

RUN npm install express@4.13.4
RUN npm install -g express-generator@4

USER bitnami
WORKDIR /app
EXPOSE 3000

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["npm", "start"]
