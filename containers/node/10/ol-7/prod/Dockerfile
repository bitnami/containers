
FROM bitnami/node:10.7.0-ol-7-r15 as development

FROM bitnami/oraclelinux-runtimes:7-r30
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/node /opt/bitnami/node

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="10.7.0-ol-7-r15" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

CMD ["node"]
