FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=elasticsearch \
    BITNAMI_IMAGE_VERSION=2.3.3-r1 \
    PATH=/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_91-1 --checksum 7a43bd08c9a1fef1d98cdfb39bdb9c2023b9fc95734c910475b6e43d85aee957

# Install elasticsearch
RUN bitnami-pkg unpack elasticsearch-2.3.3-0 --checksum dc6fda1594bfa32ba5b7c9640ac83bbdf265dc59444ee683ea678a298d55be53

COPY rootfs /

VOLUME ["/bitnami/elasticsearch"]

EXPOSE 9200 9300

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "elasticsearch"]
