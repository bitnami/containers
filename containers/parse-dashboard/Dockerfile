FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=parse-dashboard \
    BITNAMI_IMAGE_VERSION=1.0.19-r2 \
    PATH=/opt/bitnami/node/bin:$PATH

# Additional modules required
RUN bitnami-pkg install node-4.6.1-0 --checksum 3eb5e4639c18b8ac19f0c7a54cc5874a738853300fd91500642f748334dd1693

# Install parsedashboard
RUN bitnami-pkg unpack parse-dashboard-1.0.19-1 --checksum 9947593995de8d10ae19daef2b2f6b3c76622d07afc799a1b5d941454ab48543

COPY rootfs /

VOLUME ["/bitnami/parse-dashboard"]

EXPOSE 4040

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "parse-dashboard"]
