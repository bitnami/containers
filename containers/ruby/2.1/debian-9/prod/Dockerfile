
FROM bitnami/ruby:2.1.10-debian-9-r23 as development

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/ruby /opt/bitnami/ruby

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.1.10-debian-9-r23" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

CMD ["irb"]
