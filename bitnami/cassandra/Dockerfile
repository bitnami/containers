FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=cassandra \
    BITNAMI_IMAGE_VERSION=3.7-r3 \
    PATH=/opt/bitnami/cassandra/bin:/opt/bitnami/java/bin:/opt/bitnami/python/bin:$PATH

# Additional modules required
RUN bitnami-pkg install python-2.7.12-1 --checksum 1ab49b32453c509cf6ff3abb9dbe8a411053e3b811753a10c7a77b4bc19606df
RUN bitnami-pkg install java-1.8.0_101-0 --checksum 66b64f987634e1348141e0feac5581b14e63064ed7abbaf7ba5646e1908219f9

# Install cassandra
RUN bitnami-pkg unpack cassandra-3.7-0 --checksum 6f77f2f33bb075e56a485c873bc80cc260eb5848d2061805f42c7b9e95d03790

COPY rootfs /

VOLUME ["/bitnami/cassandra"]

EXPOSE 7000 7001 9042 9160

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "cassandra"]
