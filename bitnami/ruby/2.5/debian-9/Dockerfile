FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl ghostscript git imagemagick libc6 libgmp-dev libncurses5 libreadline7 libssl1.1 libtinfo5 libxml2-dev libxslt1-dev pkg-config unzip wget zlib1g zlib1g-dev
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/ruby-2.5.1-0-linux-amd64-debian-9.tar.gz && \
    echo "51f464f3a76f63ed04c05668236357de3a01a3eff9ecd64d3a1a1c697a85200d  /tmp/bitnami/pkg/cache/ruby-2.5.1-0-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/ruby-2.5.1-0-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/ruby-2.5.1-0-linux-amd64-debian-9.tar.gz
RUN /opt/bitnami/ruby/bin/gem install bundler

ENV BITNAMI_APP_NAME="ruby" \
    BITNAMI_IMAGE_VERSION="2.5.1-debian-9-r25" \
    PATH="/opt/bitnami/ruby/bin:$PATH"

EXPOSE 3000

WORKDIR /app
CMD ["irb"]
