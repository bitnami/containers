FROM bitnami/oraclelinux-extras:7-r13

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages make nc mysql-devel gcc-c++ libxml2 zlib-devel ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline unzip wget 
RUN bitnami-pkg install ruby-2.5.1-0 --checksum ec0d6bd902785a38ac057bc6e9ff243c78d5973e5345adeadc81184d32453511
RUN bitnami-pkg unpack mysql-client-10.1.35-0 --checksum e8b7b1feec15c0dd8c1643eb0ab0220c384e1eb981e1ef7cd51d06bb9fb09e6e

ENV PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:$PATH

# Ruby on Rails template
RUN gem install rails -v 5.2.1 --no-document

# Bundle the gems required for a new application
RUN rails new /tmp/temp_app --database mysql --quiet && rm -r /tmp/temp_app
RUN gem install therubyracer

ENV RAILS_ENV=development
ENV BITNAMI_APP_NAME=rails
ENV BITNAMI_IMAGE_VERSION=5.2.1-ol-7

COPY rootfs/ /

USER bitnami

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
