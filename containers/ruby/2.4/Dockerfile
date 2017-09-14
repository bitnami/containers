FROM bitnami/minideb-extras:jessie-r22-buildpack
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libc6 libgmp-dev libmysqlclient18 libncurses5 libpq5 libreadline6 libssl1.0.0 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.4.2-0 --checksum 947456b3ef36072599c35e16777240eb25eb88c6d60216f538e396d7fc8fc5a5

COPY rootfs /

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.4.2-r0" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["irb"]
