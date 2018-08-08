
FROM bitnami/ruby:2.5.1-ol-7-r44 as development

FROM bitnami/oraclelinux-runtimes:7-r36
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/ruby /opt/bitnami/ruby

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.5.1-ol-7-r44" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

CMD ["irb"]
