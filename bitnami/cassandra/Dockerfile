FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=cassandra \
    BITNAMI_IMAGE_VERSION=3.9-r0 \
    PATH=/opt/bitnami/cassandra/bin:/opt/bitnami/java/bin:/opt/bitnami/python/bin:$PATH

# Additional modules required
RUN bitnami-pkg install python-2.7.12-1 --checksum 1ab49b32453c509cf6ff3abb9dbe8a411053e3b811753a10c7a77b4bc19606df
RUN bitnami-pkg install java-1.8.0_101-0 --checksum 66b64f987634e1348141e0feac5581b14e63064ed7abbaf7ba5646e1908219f9

# Install cassandra
RUN bitnami-pkg unpack cassandra-3.9-0 --checksum bb0ff4d2e03e06e2141572c0068ce2fbfa6ec10bdbe4308a3a7a571b9cbde87f

COPY rootfs /

VOLUME ["/bitnami/cassandra"]

EXPOSE 7000 7001 9042 9160

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "cassandra"]
