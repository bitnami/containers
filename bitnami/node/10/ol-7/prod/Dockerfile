
FROM bitnami/node:10.15.0-ol-7-r25 as development

FROM bitnami/oraclelinux-runtimes:7-r205
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/node /opt/bitnami/node

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="10.15.0-ol-7-r25" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

CMD [ "node" ]
