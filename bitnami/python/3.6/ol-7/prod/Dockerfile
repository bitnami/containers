
FROM bitnami/python:3.6.6-ol-7-r31 as development

FROM bitnami/oraclelinux-runtimes:7-r78
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/python /opt/bitnami/python

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.6.6-ol-7-r31" \
    PATH="/opt/bitnami/python/bin:$PATH"

CMD [ "python" ]
