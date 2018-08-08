
FROM bitnami/node:10.7.0-ol-7-r21 as development

FROM bitnami/oraclelinux-runtimes:7-r36
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/node /opt/bitnami/node

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="10.7.0-ol-7-r21" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

CMD ["node"]
