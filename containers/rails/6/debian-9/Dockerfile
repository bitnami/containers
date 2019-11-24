FROM bitnami/minideb-extras:stretch-r494
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential default-libmysqlclient-dev ghostscript imagemagick libbz2-1.0 libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libxml2-dev libxslt1-dev netcat-traditional zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.6.5-0 --checksum 3a856a4569b5d4f59628209a1ab1b78619647bf1f4d5f11ca3ae6b28ee1e7fa9
RUN bitnami-pkg install node-10.17.0-1 --checksum 0b7f3de4f463789d093f5fb9c7647d43f20035714bc48f67aac4faf31f2e4446
RUN bitnami-pkg install mysql-client-10.3.20-0 --checksum 743aff4ba4858e3eb7d3e10ec9d7ae08b5ddbbb3257cfbbba73062991605e5e6
RUN bitnami-pkg install git-2.24.0-0 --checksum dee050702e785983e6d45c1ec197c99ffa9f12b38fe5574f53a11c16ba8435ba
RUN bitnami-pkg install rails-6.0.1-0-0 --checksum c3c10b5e74b21fd1604652eae8e20f3c8c2c15495c1f21de1c736a0dab7c1036
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.0.1-0-debian-9-r8" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:$PATH" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
