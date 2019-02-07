FROM bitnami/java:1.8.201-ol-7-r8 as development

######

FROM bitnami/oraclelinux-runtimes:7-r226
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc libgcc wget

COPY --from=development /opt/bitnami/java /opt/bitnami/java

ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="1.8.201-ol-7-r5-prod" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:$PATH"

CMD [ "bash" ]
