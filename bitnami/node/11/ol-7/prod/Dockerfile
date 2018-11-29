
FROM bitnami/node:11.3.0-ol-7-r1 as development

FROM bitnami/oraclelinux-runtimes:7-r154
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/node /opt/bitnami/node

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="11.3.0-ol-7-r1" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

CMD [ "node" ]
