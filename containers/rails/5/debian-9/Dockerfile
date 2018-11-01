FROM bitnami/minideb-extras:stretch-r184
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential default-libmysqlclient-dev ghostscript imagemagick libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libxml2-dev libxslt1-dev netcat-traditional zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.4.5-0 --checksum 6b8fe1a5db54cc642125e96caf239329d27b2871cd0830a4158c312668a2afc7
RUN bitnami-pkg install mysql-client-10.1.36-2 --checksum cae816bb8317abe3c2281c4d8787a9b293a3935e8caa4fc700a54429675755ae
RUN bitnami-pkg install git-2.19.1-2 --checksum afed897918bbbf73d72e4cb9b72e30dc43b09ed322d390e0cee889ee75c2e080
RUN bitnami-pkg install rails-5.2.1-0 --checksum 5a803d0b5187376882c0e656ac157723440d0cce68c70f9522ca79966669d779
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="5.2.1-debian-9-r2" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:$PATH" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
