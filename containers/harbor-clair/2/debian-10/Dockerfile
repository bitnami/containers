FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcom-err2 libcurl4 libffi6 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 procps rpm tar xz-utils zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.36.1-0" --checksum e00f740b66faf2808cb8983a39b186d43a8367730512c402df78751a9cefbfc1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-0" --checksum 0603c8eaf6d24e76563431e36e512da06bfebb3a06ede31b3e84d9879213c162
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-clair" "2.5.1-0" --checksum a21d3d764d738bba30744bf003d7f19aa3c90b94ea310da1c0137c93cc22638d
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-clair/postunpack.sh
ENV APP_VERSION="2.5.1" \
    BITNAMI_APP_NAME="harbor-clair" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/git/bin:/opt/bitnami/harbor-clair/bin:$PATH"

EXPOSE 6060 6061

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-clair/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-clair/run.sh" ]
