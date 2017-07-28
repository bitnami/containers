FROM bitnami/minideb-extras:jessie-r14-buildpack
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.3.4-r1" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libc6 libffi6 libgmp-dev libmysqlclient18 libncurses5 libpq5 libreadline6 libssl1.0.0 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.3.4-0 --checksum 92d6db7a6ba0893334e9d1d46a66a7459df08e151762f87942d6b0f29db0171a

COPY rootfs /


EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["irb"]
