FROM gcr.io/stacksmith-images/minideb-buildpack:jessie-r10

MAINTAINER Bitnami <containers@bitnami.com>

# System packages required
RUN install_packages libc6 libssl1.0.0 zlib1g libreadline6 libncurses5 libtinfo5 libffi6 libxml2-dev zlib1g-dev libxslt1-dev libgmp-dev ghostscript imagemagick libmysqlclient18 libpq5

RUN bitnami-pkg unpack ruby-2.4.0-1 --checksum c42ef6b39fe67b3fc60e41e42aa5d3a39de0f714069369a15342ceed0b53a6a5

COPY rootfs /

ENV PATH=/opt/bitnami/ruby/bin:$PATH

ENV BITNAMI_APP_NAME=ruby \
    BITNAMI_IMAGE_VERSION=2.4.0-r1

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["irb"]
