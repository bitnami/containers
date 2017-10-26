FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl ghostscript git imagemagick libc6 libgmp-dev libmysqlclient18 libncurses5 libpq5 libreadline6 libssl1.0.0 libtinfo5 libxml2-dev libxslt1-dev pkg-config unzip wget zlib1g zlib1g-dev
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/ruby-2.2.8-0-linux-x64-debian-8.tar.gz && \
    echo "06deb969b93894a564d1d20ba9ca7e315da9ea84947f61a6073d8b5e6f907ae9  /tmp/bitnami/pkg/cache/ruby-2.2.8-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/ruby-2.2.8-0-linux-x64-debian-8.tar.gz -P --transform 's|^.*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/ruby-2.2.8-0-linux-x64-debian-8.tar.gz
RUN /opt/bitnami/ruby/bin/gem install bundler

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.2.8-r1" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD ["irb"]
