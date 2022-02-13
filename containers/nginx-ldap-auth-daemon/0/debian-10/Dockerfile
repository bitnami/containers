FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgmp10 libgnutls30 libhogweed4 libidn2-0 libldap-2.4-2 liblzma5 libncursesw6 libnettle6 libp11-kit0 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libtasn1-6 libtinfo6 libunistring2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.9.10-19" --checksum 687bbcd5ea98e59850de3a452d8686e923492a0ef02828c5c1a0262e24cd6b16
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx-ldap-auth-daemon" "0.20200116.0-8" --checksum baade11760e7b4941eccd869b32139e13d7273162ab789efdf9a89f20506691f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
ENV BITNAMI_APP_NAME="nginx-ldap-auth-daemon" \
    BITNAMI_IMAGE_VERSION="0.20200116.0-debian-10-r586" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/nginx-ldap-auth-daemon/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8888

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nginx-ldap-auth-daemon/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx-ldap-auth-daemon/run.sh" ]
