FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgmp10 libgnutls30 libhogweed4 libidn2-0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libp11-kit0 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libtasn1-6 libtinfo6 libunistring2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.6.12-9" --checksum dd96ca7e71f61e54480761078c84f834a2145b9ea4dab1ad3305ca6e7d0bdf68
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx-ldap-auth-daemon" "0.20200116.0-2" --checksum 2b8d45c561b5c23ec090898f1d5de35caa5090a8e7ffe600a72065f802e5ba5e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
ENV BITNAMI_APP_NAME="nginx-ldap-auth-daemon" \
    BITNAMI_IMAGE_VERSION="0.20200116.0-debian-10-r181" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/nginx-ldap-auth-daemon/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8888

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nginx-ldap-auth-daemon/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx-ldap-auth-daemon/run.sh" ]
