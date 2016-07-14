FROM gcr.io/stacksmith-images/ubuntu:14.04-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=elasticsearch \
    BITNAMI_IMAGE_VERSION=2.3.4-r0 \
    PATH=/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_91-1 --checksum 7a43bd08c9a1fef1d98cdfb39bdb9c2023b9fc95734c910475b6e43d85aee957

# Install elasticsearch
RUN bitnami-pkg unpack elasticsearch-2.3.4-0 --checksum dccbe8425296e87aed6510159038cefe2f0f35a50c35c891c28ba616b67efcf1

COPY rootfs /

VOLUME ["/bitnami/elasticsearch"]

EXPOSE 9200 9300

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "elasticsearch"]
