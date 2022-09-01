FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2022.7.31-debian-11-r7" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/dokuwiki" \
      org.opencontainers.image.title="dokuwiki" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2022.7.31"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git gzip libbrotli1 libbsd0 libbz2-1.0 libc6 libcom-err2 libcrypt1 libcurl4 libexpat1 libffi7 libfftw3-double3 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmd0 libmemcached11 libnettle8 libnghttp2-14 libonig5 libp11-kit0 libpcre2-8-0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline8 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sqlite3 tar zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f php-7.4.30-160-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/php-7.4.30-160-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "a9d5c0ad78371d55d1104ac4d1e956f31897f30e26c08ab3ab14f5a4cbf9a6a0  php-7.4.30-160-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf php-7.4.30-160-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf php-7.4.30-160-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f apache-2.4.54-155-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/apache-2.4.54-155-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "28b4021842650460745bdf6985972c6ec32ef2698240ff610ce6a94412b5bfcd  apache-2.4.54-155-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf apache-2.4.54-155-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf apache-2.4.54-155-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f libphp-7.4.30-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/libphp-7.4.30-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "a3042db70c0790b362497d89b12564a1c29e21a843b10adaa68c318ac0c505b1  libphp-7.4.30-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf libphp-7.4.30-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf libphp-7.4.30-153-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f render-template-1.0.3-153-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/render-template-1.0.3-153-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "c1f2cdabdcc920512e8936ab2c8a033e1aeb97801fa026f0b12432581bf849ae  render-template-1.0.3-153-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf render-template-1.0.3-153-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf render-template-1.0.3-153-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f gosu-1.14.0-154-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab  gosu-1.14.0-154-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf gosu-1.14.0-154-linux-amd64-debian-11.tar.gz
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    if [ ! -f dokuwiki-2022.7.31-2-linux-amd64-debian-11.tar.gz ]; then \
      curl -SsLf https://downloads.bitnami.com/files/stacksmith/dokuwiki-2022.7.31-2-linux-amd64-debian-11.tar.gz -O ; \
    fi && \
    echo "0f45f8f7727171695c15a5b32063872218adfba84ffa3234ff528e73c96daf15  dokuwiki-2022.7.31-2-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf dokuwiki-2022.7.31-2-linux-amd64-debian-11.tar.gz -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
    rm -rf dokuwiki-2022.7.31-2-linux-amd64-debian-11.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/apache/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/apache-modphp/postunpack.sh
RUN /opt/bitnami/scripts/dokuwiki/postunpack.sh
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APP_VERSION="2022.7.31" \
    BITNAMI_APP_NAME="dokuwiki" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/dokuwiki/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]
