FROM bitnami/minideb-extras:jessie-r22-buildpack
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libc6 libgmp-dev libmysqlclient18 libncurses5 libpq5 libreadline6 libssl1.0.0 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.2.8-0 --checksum 06deb969b93894a564d1d20ba9ca7e315da9ea84947f61a6073d8b5e6f907ae9

COPY rootfs /

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.2.8-r0" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["irb"]
