FROM bitnami/minideb-extras:stretch-r166
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 netcat zlib1g
RUN bitnami-pkg install node-7.10.1-1 --checksum 53362288e961d298a724353710a31901d4cb8237894a26a2f676b35450c02975
RUN bitnami-pkg install express-generator-4.16.0-0 --checksum 713814e0b5a01f398c32f7caaa007c661d28dffc093133decdbdb360433a8742
RUN bitnami-pkg install express-4.16.4-0 --checksum 064afcdc436fcafcdcb83347969b20e8e686b2913b50839fa409db7f48cbd8ac
RUN mkdir -p /dist /app /.npm && chmod g+rwx /app /dist /.npm

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.16.4-debian-9-r3" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/express/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
