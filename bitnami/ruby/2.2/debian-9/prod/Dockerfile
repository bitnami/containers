
FROM bitnami/ruby:2.2.10-debian-9-r29 as development

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/ruby /opt/bitnami/ruby

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.2.10-debian-9-r29" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

CMD ["irb"]
