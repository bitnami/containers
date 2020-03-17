FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/common/bin:/opt/bitnami/parse/bin:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr ghostscript gnupg imagemagick libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 procps sudo unzip zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install node-12.16.1-0 --checksum 36bab987be1cc792c7155e30545b004b76fc9a81796afec343a0a698935204b2
RUN bitnami-pkg install mongodb-client-4.2.4-0 --checksum 569ea188bce8a41ea9d5725052e74a006c648843397e1863da5b31b6422549e2
RUN bitnami-pkg install tini-0.18.0-3 --checksum 1e9b72b6636c6a48397a18df2363b44461e87ad7f892c179a9115c7525ed9327
RUN bitnami-pkg unpack parse-4.1.0-0 --checksum 4d3d396a0e15e5d9d11aea8db79cda65439cb5bfec5871d9e1ebb775ae03c966
RUN bitnami-pkg install gosu-1.11.0-3 --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root parse

COPY rootfs /
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="4.1.0-debian-10-r0" \
    MONGODB_HOST="mongodb" \
    MONGODB_PASSWORD="" \
    MONGODB_PORT_NUMBER="27017" \
    MONGODB_USER="root" \
    NAMI_PREFIX="/.nami" \
    PARSE_APP_ID="myappID" \
    PARSE_ENABLE_CLOUD_CODE="no" \
    PARSE_HOST="127.0.0.1" \
    PARSE_MASTER_KEY="mymasterKey" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_PORT_NUMBER="1337"

EXPOSE 1337

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
