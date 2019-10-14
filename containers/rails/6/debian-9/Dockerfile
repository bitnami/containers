FROM bitnami/minideb-extras:stretch-r493
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential default-libmysqlclient-dev ghostscript imagemagick libbz2-1.0 libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libxml2-dev libxslt1-dev netcat-traditional zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.6.5-0 --checksum 3a856a4569b5d4f59628209a1ab1b78619647bf1f4d5f11ca3ae6b28ee1e7fa9
RUN bitnami-pkg install node-10.16.3-1 --checksum 28271023b7668fd4c8cffe0a39c0fa9b642443e101b84d724018abf86e807143
RUN bitnami-pkg install mysql-client-10.3.18-2 --checksum 9ba76d9543cc87642f23cc4987e12750e8690d45274c3701aa429ef19e3b8e08
RUN bitnami-pkg install git-2.23.0-1 --checksum c473c33b37175fe4d1b4f6ec63ccfd0aea79669aab082e4c45b73e90a032568b
RUN bitnami-pkg install rails-6.0.0-0-1 --checksum 6347ae92a9ad18fa16836274a381068737b764dd5678d50165e69bcbdf73a1db
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.0.0-0-debian-9-r38" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:$PATH" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
