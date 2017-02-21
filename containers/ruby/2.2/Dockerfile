FROM gcr.io/stacksmith-images/minideb-buildpack:jessie-r10

MAINTAINER Bitnami <containers@bitnami.com>

# System packages required
RUN install_packages libc6 libssl1.0.0 zlib1g libreadline6 libncurses5 libtinfo5 libffi6 libxml2-dev zlib1g-dev libxslt1-dev libgmp-dev ghostscript imagemagick libmysqlclient18 libpq5

RUN bitnami-pkg unpack ruby-2.2.6-2 --checksum be1e9359fcbe2e70742a79fe270537932a62833bec67d0c7ba6a0b505dcd35ce

COPY rootfs /

ENV PATH=/opt/bitnami/ruby/bin:$PATH

ENV BITNAMI_APP_NAME=ruby \
    BITNAMI_IMAGE_VERSION=2.2.6-r0

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["irb"]
