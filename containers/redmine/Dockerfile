FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=redmine \
    BITNAMI_IMAGE_VERSION=3.3.1-r4 \
    PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH

# Additional modules required
RUN bitnami-pkg install ruby-2.1.10-1 --checksum aa7c266eda9468e204980b41427a0566176aff5103b6ef96b81f86a525bc8772
RUN bitnami-pkg install imagemagick-6.7.5-10-4 --checksum 02caf58e61a89db57ff3f62a412298fbaeff320cf32e196c9439959a197ed73d
RUN bitnami-pkg install mysql-libraries-10.1.13-2 --checksum 1b61acd1d1f0f204d1e2b0b59411d21c2d5724edd4cdf1d7925de0819213a6ad
RUN bitnami-pkg install mysql-client-10.1.19-0 --checksum fdbc292bedabeaf0148d66770b8aa0ab88012ce67b459d6ba2b46446c91bb79c
RUN bitnami-pkg install git-2.6.1-2 --checksum edc04dc263211f3ffdc953cb96e5e3e76293dbf7a97a075b0a6f04e048b773dd

# Install redmine
RUN bitnami-pkg unpack redmine-3.3.1-3 --checksum 7edd3c6fe6a95c0fa68993ce6f327b06713a32a76b8c6396aebb464c2bd88c8a

COPY rootfs /

VOLUME ["/bitnami/redmine"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "redmine"]
