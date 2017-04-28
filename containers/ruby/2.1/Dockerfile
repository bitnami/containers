FROM bitnami/minideb-extras:jessie-r14-buildpack
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.1.10-r3" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libc6 libffi6 libgmp-dev libmysqlclient18 libncurses5 libpq5 libreadline6 libssl1.0.0 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.1.10-4 --checksum 205f8f287dec90b00d41cc3399280276a950ac4139c2937f97d937f6aca94630

COPY rootfs /


EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["irb"]
