
FROM bitnami/node:8 as development

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/node /opt/bitnami/node

ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="8.11.3-debian-8-r20" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

CMD ["node"]
