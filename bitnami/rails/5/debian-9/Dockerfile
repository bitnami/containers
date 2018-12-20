FROM bitnami/minideb-extras:stretch-r227
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential default-libmysqlclient-dev ghostscript imagemagick libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libxml2-dev libxslt1-dev netcat-traditional zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.4.5-20 --checksum f1496dcc6b4fce4c661c6af478ac989cbc9717f96fc916499a78b9cf8e7fb3d2
RUN bitnami-pkg install mysql-client-10.1.37-20 --checksum 414e98c1024187f1f0300eb3571f3d5ae54cdb36f3f08430be634714700bd1d9
RUN bitnami-pkg install git-2.19.2-0 --checksum 24817a90223cfc91ce38cdc459dc6647dcf36754bf0300433ddb00ec276757ff
RUN bitnami-pkg install rails-5.2.2-20 --checksum d29500cbf2d1a31a9101b2594b0034be8e0c1dedfc86b373a62b3d82d5954236
RUN curl -sLo yq https://github.com/mikefarah/yq/releases/download/2.2.0/yq_linux_amd64 && \
    chmod +x yq && mv yq /usr/local/bin/
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="5.2.2-debian-9-r17" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:$PATH" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
