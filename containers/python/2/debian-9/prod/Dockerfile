
FROM bitnami/python:2.7.15-debian-9-r31 as development

FROM bitnami/minideb-runtimes:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/python /opt/bitnami/python

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="2.7.15-debian-9-r31" \
    PATH="/opt/bitnami/python/bin:$PATH"

CMD ["python"]
