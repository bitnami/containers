
FROM bitnami/python:3.6.5-debian-8-r67 as development

FROM bitnami/minideb-runtimes:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/python /opt/bitnami/python

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.6.5-debian-8-r67" \
    PATH="/opt/bitnami/python/bin:$PATH"

CMD ["python"]
