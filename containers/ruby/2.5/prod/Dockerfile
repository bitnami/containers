
FROM bitnami/ruby:2.5.1-debian-8-r72 as development

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/ruby /opt/bitnami/ruby

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.5.1-debian-8-r72" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

CMD ["irb"]
