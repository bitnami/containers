
FROM bitnami/python:2.7.15-ol-7-r194 as development

FROM bitnami/oraclelinux-runtimes:7-r210
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/python /opt/bitnami/python

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="2.7.15-ol-7-r194" \
    PATH="/opt/bitnami/python/bin:$PATH"

CMD [ "python" ]
