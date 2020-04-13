FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/common/bin:/opt/bitnami/rails/bin:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl default-libmysqlclient-dev dirmngr ghostscript gnupg imagemagick libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libxml2-dev libxslt1-dev netcat-traditional procps sudo unzip zlib1g zlib1g-dev
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install ruby-2.6.6-0 --checksum ecadce77e40822926c69f76cc11437954dd068793548c3f0a21007f9c4fafed3
RUN bitnami-pkg install node-10.20.1-0 --checksum 9f511612b5c1cf1b0b77ff38c73b970be17f498f1b4d4e995f907cdd75c92504
RUN bitnami-pkg install mysql-client-10.3.22-1 --checksum e9fa94f574c87d15f0b6aba7cff1c06f70c0e69c1c442378c9961fc148fa68ef
RUN bitnami-pkg install git-2.26.0-0 --checksum a49e9389b493b336e2c012f3ccd4632a20296029b15b1dd948a879bc9ddc7b06
RUN bitnami-pkg install tini-0.18.0-3 --checksum 1e9b72b6636c6a48397a18df2363b44461e87ad7f892c179a9115c7525ed9327
RUN bitnami-pkg install rails-6.0.2-2-0 --checksum a34b9ea6f083c5a019aaf7548cc9af90b0a8dc2c3a530b7c80005a7482900ab9
RUN bitnami-pkg install gosu-1.11.0-3 --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir /app && chown bitnami:bitnami /app

COPY rootfs /
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.0.2-2-debian-10-r23" \
    BUNDLE_BUILD__SASSC="--disable-march-tune-native" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
