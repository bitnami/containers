
FROM bitnami/python:3.7.0-ol-7-r19 as development

FROM bitnami/oraclelinux-runtimes:7-r39
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/python /opt/bitnami/python

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.7.0-ol-7-r19" \
    PATH="/opt/bitnami/python/bin:$PATH"

CMD ["python"]
