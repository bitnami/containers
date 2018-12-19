
FROM bitnami/ruby:2.3.8-ol-7-r51 as development

FROM bitnami/oraclelinux-runtimes:7-r174
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/ruby /opt/bitnami/ruby

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.3.8-ol-7-r51" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

CMD [ "irb" ]
