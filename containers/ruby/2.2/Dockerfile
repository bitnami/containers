FROM bitnami/minideb-extras:jessie-r21-buildpack
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libc6 libgmp-dev libmysqlclient18 libncurses5 libpq5 libreadline6 libssl1.0.0 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.2.7-1 --checksum 0f118a4ff5218a5b25e0d2e6597ac538e7978c01e174d52ca9333b02e14222ef

COPY rootfs /

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.2.7-r2" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["irb"]
