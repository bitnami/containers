FROM gcr.io/stacksmith-images/ubuntu:14.04-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.4.25-r2 \
    BITNAMI_APP_NAME=memcached \
    BITNAMI_APP_USER=memcached

RUN bitnami-pkg unpack memcached-1.4.25-2 --checksum b664b38a29a3e69f9ef61599aff647a868e00e8da8baccc976def58b2cd16b4e
ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "memcached"]

EXPOSE 11211
