
FROM bitnami/ruby:2.1.10-debian-8-r75 as development

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/ruby /opt/bitnami/ruby

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.1.10-debian-8-r75" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

CMD ["irb"]
