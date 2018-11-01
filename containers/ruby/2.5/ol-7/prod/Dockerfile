
FROM bitnami/ruby:2.5.3-ol-7-r15 as development

FROM bitnami/oraclelinux-runtimes:7-r127
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/ruby /opt/bitnami/ruby

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.5.3-ol-7-r15" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

CMD [ "irb" ]
