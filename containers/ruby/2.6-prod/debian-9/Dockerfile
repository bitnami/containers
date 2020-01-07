FROM bitnami/ruby:2.6.5-debian-9-r83 as development

######

FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates ghostscript imagemagick libc6 libgmp-dev libncurses5 libreadline7 libssl1.0.2 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

COPY --from=development /opt/bitnami/ruby /opt/bitnami/ruby

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.6.5-debian-9-r78-prod" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

CMD [ "irb" ]
