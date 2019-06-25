FROM bitnami/java:11.0.3-ol-7-r58 as development

######

FROM bitnami/oraclelinux-runtimes:7-r349
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc wget zlib

COPY --from=development /opt/bitnami/java /opt/bitnami/java

ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="11.0.3-ol-7-r57-prod" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:$PATH"

CMD [ "bash" ]
