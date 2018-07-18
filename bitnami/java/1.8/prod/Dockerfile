
FROM bitnami/java:1.8.181-debian-8-r0 as development

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/java /opt/bitnami/java

ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="1.8.181-debian-8-r0" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:$PATH"

CMD ["bash"]
