
FROM bitnami/python:3.7.0-debian-9-r11 as development

FROM bitnami/minideb-runtimes:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/python /opt/bitnami/python

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.7.0-debian-9-r11" \
    PATH="/opt/bitnami/python/bin:$PATH"

CMD ["python"]
