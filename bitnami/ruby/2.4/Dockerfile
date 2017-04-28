FROM bitnami/minideb-extras:jessie-r14-buildpack
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.4.1-r1" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libc6 libffi6 libgmp-dev libmysqlclient18 libncurses5 libpq5 libreadline6 libssl1.0.0 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.4.1-0 --checksum eaf2341624588774f61e4aac4f53c437e98b1e97f6915ba6327d3ecdc6c2c3a2

COPY rootfs /


EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["irb"]
