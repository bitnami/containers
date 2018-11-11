
FROM bitnami/node:11.1.0-ol-7-r3 as development

FROM bitnami/oraclelinux-runtimes:7-r137
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/node /opt/bitnami/node

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="11.1.0-ol-7-r3" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

CMD [ "node" ]
