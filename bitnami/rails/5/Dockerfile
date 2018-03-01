FROM bitnami/minideb-extras:jessie-r24-buildpack

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages ghostscript imagemagick libc6 libffi6 libgcc1 libgmp-dev libmysqlclient18 libmysqlclient-dev libncurses5 libpq5 libreadline6 libssl1.0.0 libssl1.0.0 libstdc++6 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev netcat-traditional

RUN bitnami-pkg install ruby-2.5.0-0 --checksum a6cd78a98b1e260de6f62cbd94b7fb4ddb0b2a7ea2e0928bd1482158de519ebf
RUN bitnami-pkg install mysql-client-10.1.31-0 --checksum c5140f9fd386782201b78559972045018928a405df324564deb392c6c61073c1

ENV PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:$PATH

# Ruby on Rails template
RUN gem install rails -v 5.1.5 --no-document

# Bundle the gems required for a new application
RUN rails new /tmp/temp_app --database mysql --quiet && rm -r /tmp/temp_app
RUN gem install therubyracer

ENV RAILS_ENV=development
ENV BITNAMI_APP_NAME=rails
ENV BITNAMI_IMAGE_VERSION=5.1.5-r0

COPY rootfs/ /

USER bitnami

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
