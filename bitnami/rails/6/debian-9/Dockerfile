FROM bitnami/minideb-extras:stretch-r480
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential default-libmysqlclient-dev ghostscript imagemagick libbz2-1.0 libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libxml2-dev libxslt1-dev netcat-traditional zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.6.4-0 --checksum d3850ff8359e897e10fd224371b34a5334e3f2ae1f79a73ab138d74987d61a72
RUN bitnami-pkg install node-10.16.3-0 --checksum 6c6466b1645568da237ba1bb079a52ca5661aedcf04d832728890b78a3e48689
RUN bitnami-pkg install mysql-client-10.3.18-1 --checksum 0923287dea11bd5880530ca456435e3f4c1c089bee2f8eea1dbf69821478e370
RUN bitnami-pkg install git-2.23.0-0 --checksum 54731b0fecdf38ab559cdd76311a229915bf0581b213a5806d3c7d56c5399981
RUN bitnami-pkg install rails-6.0.0-0-0 --checksum 1b3be0d532e8c4e04e085d5a7575a364ae348dcdbb84914ab3bbd56da8b896e4
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.0.0-0-debian-9-r13" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:$PATH" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
