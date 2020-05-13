FROM bitnami/python:3.6.10-debian-10-r113 as development

######

FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbz2-1.0 libc6 libffi6 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps sudo unzip zlib1g
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/' /etc/login.defs && \
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    0/' /etc/login.defs && \
    sed -i 's/sha512/sha512 minlen=8/' /etc/pam.d/common-password

COPY --from=development /opt/bitnami/licenses /opt/bitnami/licenses
COPY --from=development /opt/bitnami/python /opt/bitnami/python

ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.6.10-debian-10-r106-prod" \
    PATH="/opt/bitnami/python/bin:$PATH"

CMD [ "python" ]
