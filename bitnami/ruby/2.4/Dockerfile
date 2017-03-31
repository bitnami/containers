FROM bitnami/minideb-extras:jessie-r13-buildpack

MAINTAINER Bitnami <containers@bitnami.com>

# System packages required
RUN install_packages libc6 libssl1.0.0 zlib1g libreadline6 libncurses5 libtinfo5 libffi6 libxml2-dev zlib1g-dev libxslt1-dev libgmp-dev ghostscript imagemagick libmysqlclient18 libpq5

RUN bitnami-pkg install ruby-2.4.1-0 --checksum eaf2341624588774f61e4aac4f53c437e98b1e97f6915ba6327d3ecdc6c2c3a2

COPY rootfs /

ENV PATH=/opt/bitnami/ruby/bin:$PATH

ENV BITNAMI_APP_NAME=ruby \
    BITNAMI_IMAGE_VERSION=2.4.1-r0

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["irb"]
