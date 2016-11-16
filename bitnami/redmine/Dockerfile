FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=redmine \
    BITNAMI_IMAGE_VERSION=3.3.1-r5 \
    PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH

# Additional modules required
RUN bitnami-pkg install ruby-2.1.10-2 --checksum 2382f4f15ec657846a2090f5d05a8aa5cf7a77312d56b250653ef0bf00108a7f
RUN bitnami-pkg install imagemagick-6.7.5-10-4 --checksum 02caf58e61a89db57ff3f62a412298fbaeff320cf32e196c9439959a197ed73d
RUN bitnami-pkg install mysql-libraries-10.1.13-2 --checksum 1b61acd1d1f0f204d1e2b0b59411d21c2d5724edd4cdf1d7925de0819213a6ad
RUN bitnami-pkg install mysql-client-10.1.19-0 --checksum fdbc292bedabeaf0148d66770b8aa0ab88012ce67b459d6ba2b46446c91bb79c
RUN bitnami-pkg install git-2.6.1-2 --checksum edc04dc263211f3ffdc953cb96e5e3e76293dbf7a97a075b0a6f04e048b773dd

# Install redmine
RUN bitnami-pkg unpack redmine-3.3.1-4 --checksum b25b45a4a54956af7858839d41b8a09c6f84aabb35d0f261e9b9e1e10465c38d

COPY rootfs /

VOLUME ["/bitnami/redmine"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "redmine"]
