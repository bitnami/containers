FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=cassandra \
    BITNAMI_IMAGE_VERSION=3.9-r1 \
    PATH=/opt/bitnami/cassandra/bin:/opt/bitnami/java/bin:/opt/bitnami/python/bin:$PATH

# Additional modules required
RUN bitnami-pkg install python-2.7.12-1 --checksum 1ab49b32453c509cf6ff3abb9dbe8a411053e3b811753a10c7a77b4bc19606df
RUN bitnami-pkg install java-1.8.0_111-0 --checksum a40aa0c9553e13bd8ddcc3d2ba966492b79d4f73d47cb1499c9ec54f441201eb

# Install cassandra
RUN bitnami-pkg unpack cassandra-3.9-1 --checksum b80d0f763ffa48af5652577c3194f2ea0f0fc09fbf7a745ec39b6c7b73fe265d

COPY rootfs /

VOLUME ["/bitnami/cassandra"]

EXPOSE 7000 7001 9042 9160

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "cassandra"]
