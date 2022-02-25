FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-35" --checksum 338b60596e8a45b8a55ab2831bcc05a804d423da70c296e737c41616ab11f104
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "12.22.10-3" --checksum 8d2996e363a66d94c6b633bd0550de723b884725a4b2c182199989b3a9eaaec1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb-client" "4.4.12-6" --checksum 91dbf114c756e57dbeb3b1c29e1aaaf2f7bdf7ef03fd4d8227f088fa6ec2a33a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse" "4.10.6-2" --checksum e3ce7a2372f1185a4221e0eb3c9d8aed2d258df3a3895b6eb996b41f7bd0ea89
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-6" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse/postunpack.sh
ENV BITNAMI_APP_NAME="parse" \
    BITNAMI_IMAGE_VERSION="4.10.6-debian-10-r10" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/mongodb-client/bin:/opt/bitnami/parse/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 1337 3000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse/run.sh" ]
