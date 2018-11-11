
FROM bitnami/java:1.8.191-ol-7-r23 as development

FROM bitnami/oraclelinux-runtimes:7-r137
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/java /opt/bitnami/java

ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="1.8.191-ol-7-r23" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:$PATH"

CMD [ "bash" ]
