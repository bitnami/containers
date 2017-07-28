FROM bitnami/minideb-extras:jessie-r14-buildpack
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.2.7-r1" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libc6 libffi6 libgmp-dev libmysqlclient18 libncurses5 libpq5 libreadline6 libssl1.0.0 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.2.7-0 --checksum e1b4cda02aaf88007810b5bc352c26c13aee0d5c5935a0e7e69869bf204b9394

COPY rootfs /


EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["irb"]
