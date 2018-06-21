FROM bitnami/oraclelinux-extras:7-r13

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages make nc mysql-devel gcc-c++ libxml2 zlib-devel ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline unzip wget 
RUN bitnami-pkg install ruby-2.5.1-0 --checksum ec0d6bd902785a38ac057bc6e9ff243c78d5973e5345adeadc81184d32453511
RUN bitnami-pkg unpack mysql-client-10.1.34-0 --checksum 012f1f222898565b55f7d4522514c7c130d2bfe4c988754eed658ef6dafa980c

ENV PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:$PATH

# Ruby on Rails template
RUN gem install rails -v 5.2.0 --no-document

# Bundle the gems required for a new application
RUN rails new /tmp/temp_app --database mysql --quiet && rm -r /tmp/temp_app
RUN gem install therubyracer

ENV RAILS_ENV=development
ENV BITNAMI_APP_NAME=rails
ENV BITNAMI_IMAGE_VERSION=5.2.0-ol-7-r1

COPY rootfs/ /

USER bitnami

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
