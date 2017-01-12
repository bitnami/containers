FROM gcr.io/stacksmith-images/minideb-buildpack:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

# Install required system packages
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

RUN bitnami-pkg install node-7.4.0-0 --checksum 25efb29dd2c4e4f459197401843e91185fb2e1d9a60d0b58ad350bf1254f8b15

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH \
    NODE_PATH=/opt/bitnami/node/lib/node_modules

# ExpressJS template
ENV BITNAMI_APP_NAME=express
ENV BITNAMI_IMAGE_VERSION=4.14.0-r14

RUN bitnami-pkg install express-generator-4.13.4-1 --checksum 937c865650282fa55c0e543166b95b0aab9e4cf891782cee056037697b2b64e3
RUN bitnami-pkg install express-4.14.0-1 --checksum f98a7f8e85d038bb895d1105f6a0d995810b004f78b4fc0a0299237dc5070795
RUN npm install -g bower@1.8.0

COPY rootfs/ /

# The extra files that we bundle should use the Bitnami User
# so the entrypoint does not have any permission issues
RUN chown -R bitnami: /app /app_template

USER bitnami

WORKDIR /app
EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["npm", "start"]
