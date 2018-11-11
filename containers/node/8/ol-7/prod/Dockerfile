
FROM bitnami/node:8.12.0-ol-7-r58 as development

FROM bitnami/oraclelinux-runtimes:7-r137
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/node /opt/bitnami/node

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="8.12.0-ol-7-r58" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

CMD [ "node" ]
