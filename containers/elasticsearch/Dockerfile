FROM gcr.io/stacksmith-images/ubuntu:14.04-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=elasticsearch \
    BITNAMI_IMAGE_VERSION=2.4.0-r1 \
    PATH=/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_101-0 --checksum 66b64f987634e1348141e0feac5581b14e63064ed7abbaf7ba5646e1908219f9

# Install elasticsearch
RUN bitnami-pkg unpack elasticsearch-2.4.1-0 --checksum 5341f48077ba251362f9f8d99467d75922d6272312ab06986a3a46191bc12bd2

COPY rootfs /

VOLUME ["/bitnami/elasticsearch"]

EXPOSE 9200 9300

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "elasticsearch"]
