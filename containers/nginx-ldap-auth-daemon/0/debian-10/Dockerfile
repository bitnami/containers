FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgmp10 libgnutls30 libhogweed4 libidn2-0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libp11-kit0 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libtasn1-6 libtinfo6 libunistring2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.6.11-0" --checksum 2e18b5e1da1b26985355d8e4efea81bae34132debcc2fc9bc453c7cb8cca08df
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx-ldap-auth-daemon" "0.20200116.0-1" --checksum 088bacc7487000a4e20c5897ca7241553e27e19d7d352b93d7d4bb6e121f3f45
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-1" --checksum 51cfb1b7fd7b05b8abd1df0278c698103a9b1a4964bdacd87ca1d5c01631d59c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
ENV BITNAMI_APP_NAME="nginx-ldap-auth-daemon" \
    BITNAMI_IMAGE_VERSION="0.20200116.0-debian-10-r55" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/nginx-ldap-auth-daemon/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8888

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nginx-ldap-auth-daemon/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx-ldap-auth-daemon/run.sh" ]
