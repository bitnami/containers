FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=parse \
    BITNAMI_IMAGE_VERSION=2.2.23-r0 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:$PATH

# Additional modules required
RUN bitnami-pkg install node-4.6.1-0 --checksum 3eb5e4639c18b8ac19f0c7a54cc5874a738853300fd91500642f748334dd1693
RUN bitnami-pkg install mongodb-client-3.2.7-4 --checksum 251b952828fa1dfaae4063914bba46ea8a1aaf9c0954850c00ee772000077f8d

# Install parse
RUN bitnami-pkg unpack parse-2.2.23-0 --checksum 6ff0b2c4764be30ee213d5c616cfe3952b797ef69b36c8ffdfec3bf2148ac92a

COPY rootfs /

VOLUME ["/bitnami/parse"]

EXPOSE 1337

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "parse"]
