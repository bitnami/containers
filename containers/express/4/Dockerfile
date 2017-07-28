FROM bitnami/minideb-extras:jessie-r19-buildpack

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libmysqlclient18 libncurses5 libreadline6 libsqlite3-0 libssl1.0.0 libstdc++6 libtinfo5 zlib1g netcat-traditional

# Additional modules required
RUN bitnami-pkg install node-7.10.0-0 --checksum 7209e62e60335308287cba38bc18fb34245d41b86bc7ffd3ad26413f186c529b
ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH \
    NODE_PATH=/opt/bitnami/node/lib/node_modules

RUN bitnami-pkg install express-generator-4.15.0-0 --checksum 28212293bc46e35f3e5638ba3a361fd4cdfcf7be5ee70e0412e8644393255505
RUN npm install -g bower@1.8.0 sequelize-cli

# Install express
RUN bitnami-pkg install express-4.15.3-0 --checksum e511a51d76c71a36545c8c7b60ff47e428800dd91a92dc4f67ae7bc65db1b6f3
RUN rm -rf /app

# ExpressJS template
ENV BITNAMI_APP_NAME=express
ENV BITNAMI_IMAGE_VERSION=4.15.3-r2

COPY rootfs/ /

# The extra files that we bundle should use the Bitnami User
# so the entrypoint does not have any permission issues
RUN mkdir /app && chown bitnami: /app /dist

USER bitnami

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["npm", "start"]
