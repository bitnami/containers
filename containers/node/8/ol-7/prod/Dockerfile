
FROM bitnami/node:8.11.4-ol-7-r16 as development

FROM bitnami/oraclelinux-runtimes:7-r69
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/node /opt/bitnami/node

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="8.11.4-ol-7-r16" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

CMD [ "node" ]
