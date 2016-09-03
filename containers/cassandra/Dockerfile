FROM gcr.io/stacksmith-images/ubuntu:14.04-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=cassandra \
    BITNAMI_IMAGE_VERSION=3.7-r1 \
    PATH=/opt/bitnami/cassandra/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_91-1 --checksum 7a43bd08c9a1fef1d98cdfb39bdb9c2023b9fc95734c910475b6e43d85aee957
RUN bitnami-pkg install python-2.7.11-3 --checksum 51d9ebc8a10e75f420c1af1321db321e20c45386a538932c78d5e0d74192aea5

# Install cassandra
RUN bitnami-pkg unpack cassandra-3.7-0 --checksum 6f77f2f33bb075e56a485c873bc80cc260eb5848d2061805f42c7b9e95d03790

COPY rootfs /

VOLUME ["/bitnami/cassandra"]

EXPOSE 7000 7001 9042 9160

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "cassandra"]
