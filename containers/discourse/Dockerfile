FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=discourse \
    BITNAMI_IMAGE_VERSION=1.6.7 \
    PATH=/opt/bitnami/ruby/bin:/opt/bitnami/postgresql-client/bin:/opt/bitnami/git/bin:$PATH

# Additional modules required
RUN bitnami-pkg install imagemagick-6.7.5-10-4 --checksum 02caf58e61a89db57ff3f62a412298fbaeff320cf32e196c9439959a197ed73d
RUN bitnami-pkg install postgresql-libraries-9.6.1-0 --checksum 74e71a235a42ba1eb24a1bbb5b47020c2197c99a4e307d966414f3bc1deb1571
RUN bitnami-pkg install git-2.10.1-0 --checksum 9be08fdf7a0f23a1e86fb41ef7e8c54c43bf9d05890e276ae08483a0fe2802eb
RUN bitnami-pkg install postgresql-client-9.6.1-0 --checksum 01f5a09dd813d72db79ab6055e2c1cd95f41ce5883ca373381d0741cc6172719
RUN bitnami-pkg install ruby-2.3.3-0 --checksum b64b56e2b71d9ee38b8a54c073006df7ea70c2ccd8f74ced9ac8b35160134829

# Install discourse
RUN bitnami-pkg unpack discourse-1.6.7-0 --checksum b3e72cf58636f8c790b408f5355e8a7e3cbad8e45301b5ec3ea6743831bfe6ac

COPY rootfs /

VOLUME ["/bitnami/discourse"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami","start","--foreground","discourse"]
