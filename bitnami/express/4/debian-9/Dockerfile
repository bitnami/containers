FROM bitnami/minideb-extras:stretch-r185
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbz2-1.0 libc6 libgcc1 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo5 netcat zlib1g
RUN bitnami-pkg install node-7.10.1-1 --checksum 53362288e961d298a724353710a31901d4cb8237894a26a2f676b35450c02975
RUN bitnami-pkg install express-generator-4.16.0-1 --checksum 841d5bc19beae946cbd7ed69a23ac1e808b2ec28c345c1e55c40121e4684630c
RUN bitnami-pkg install express-4.16.4-2 --checksum 4ebca3306bf2de21d261d777ef9b17ebe94262b240a2d485d4d81589c2e9d414
RUN mkdir -p /dist /app /.npm && chmod g+rwx /app /dist /.npm

COPY rootfs /
ENV BITNAMI_APP_NAME="express" \
    BITNAMI_IMAGE_VERSION="4.16.4-debian-9-r21" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/express/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "npm", "start" ]
