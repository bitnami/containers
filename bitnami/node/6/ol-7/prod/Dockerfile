
FROM bitnami/node:6.15.0-ol-7-r3 as development

FROM bitnami/oraclelinux-runtimes:7-r154
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/node /opt/bitnami/node

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="6.15.0-ol-7-r3" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

CMD [ "node" ]
