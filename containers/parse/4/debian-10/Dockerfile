FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-2" --checksum e00677f5209d9426daff2db54cf00e04c46718bbdbc0717aee07e6a727ef05ad
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "12.22.6-0" --checksum 9cdaa4d224db9b040a718e445335687b57933ece70c56b3c9fc012e4998723c7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb-client" "4.4.9-0" --checksum 93f7e5b0787baaefb05b936a8a25c4e39d093bf04c27fe7ef01c1c9f4d4aabdf
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse" "4.10.4-0" --checksum 8c9d1701f73d4b715487216334da1386972584041375dc15d21ac350dc76476b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse/postunpack.sh
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="4.10.4-debian-10-r5" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/mongodb-client/bin:/opt/bitnami/parse/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 1337 3000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse/run.sh" ]
