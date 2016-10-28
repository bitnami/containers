FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=parsedashboard \
    BITNAMI_IMAGE_VERSION=1.0.19-r0 \
    PATH=/opt/bitnami/node/bin:$PATH

# Additional modules required
RUN bitnami-pkg install node-4.6.1-0 --checksum 3eb5e4639c18b8ac19f0c7a54cc5874a738853300fd91500642f748334dd1693

# Install parsedashboard
RUN bitnami-pkg unpack parsedashboard-1.0.19-0 --checksum 22afabbfd59a3f8d1caf5bbf580bf8036634cf59840b250666b594ee416005c7

COPY rootfs /

VOLUME ["/bitnami/parsedashboard"]

EXPOSE 4040

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "parsedashboard"]
