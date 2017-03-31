FROM bitnami/minideb-extras:jessie-r13-buildpack

MAINTAINER Bitnami <containers@bitnami.com>

# System packages required
RUN install_packages libc6 libssl1.0.0 zlib1g libreadline6 libncurses5 libtinfo5 libffi6 libxml2-dev zlib1g-dev libxslt1-dev libgmp-dev ghostscript imagemagick libmysqlclient18 libpq5

RUN bitnami-pkg install ruby-2.2.7-0 --checksum e1b4cda02aaf88007810b5bc352c26c13aee0d5c5935a0e7e69869bf204b9394

COPY rootfs /

ENV PATH=/opt/bitnami/ruby/bin:$PATH

ENV BITNAMI_APP_NAME=ruby \
    BITNAMI_IMAGE_VERSION=2.2.7-r0

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["irb"]
