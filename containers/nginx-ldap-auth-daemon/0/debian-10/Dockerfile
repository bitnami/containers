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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx-ldap-auth-daemon" "0.20200116.0-4" --checksum dca40a26b79fe63c5e54b2408db63c426dfa9b1be2c50b926ab1dd5857127c8b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
ENV BITNAMI_APP_NAME="nginx-ldap-auth-daemon" \
    BITNAMI_IMAGE_VERSION="0.20200116.0-debian-10-r558" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/nginx-ldap-auth-daemon/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8888

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nginx-ldap-auth-daemon/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx-ldap-auth-daemon/run.sh" ]
