FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgmp10 libgnutls30 libhogweed4 libidn2-0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libp11-kit0 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libtasn1-6 libtinfo6 libunistring2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.6.15-5" --checksum 5d96e59953a65611f9ef522a397993988a931b0a0f99736213636e1935b6a21a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx-ldap-auth-daemon" "0.20200116.0-6" --checksum eec00f52ef647233d2dce6aa1c19b51213fc99ec45bb3a3aa5aa0beeaf608261
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-2" --checksum 7419bc5e2be68eb14c92e321acc843413481cda73323fb8c0d1dda8b1e5aa9d5
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
ENV BITNAMI_APP_NAME="nginx-ldap-auth-daemon" \
    BITNAMI_IMAGE_VERSION="0.20200116.0-debian-10-r576" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/nginx-ldap-auth-daemon/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8888

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nginx-ldap-auth-daemon/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx-ldap-auth-daemon/run.sh" ]
