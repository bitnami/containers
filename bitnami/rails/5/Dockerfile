FROM bitnami/minideb-extras:jessie-r24-buildpack

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages ghostscript imagemagick libc6 libffi6 libgcc1 libgmp-dev libmysqlclient18 libmysqlclient-dev libncurses5 libpq5 libreadline6 libssl1.0.0 libssl1.0.0 libstdc++6 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev netcat-traditional

RUN bitnami-pkg install ruby-2.5.1-0 --checksum fd17ca9ec4faba06a21868c654681a79d1b00748efaefacb6805fe7e464442ef
RUN bitnami-pkg install mysql-client-10.1.32-0 --checksum e65dc7fa2dd7fa6cac74d62a2cff2e3d40f650e721ac955381dc7b6f83d4a141

ENV PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:$PATH

# Ruby on Rails template
RUN gem install rails -v 5.2.0 --no-document

# Bundle the gems required for a new application
RUN rails new /tmp/temp_app --database mysql --quiet && rm -r /tmp/temp_app
RUN gem install therubyracer

ENV RAILS_ENV=development
ENV BITNAMI_APP_NAME=rails
ENV BITNAMI_IMAGE_VERSION=5.2.0-r0

COPY rootfs/ /

USER bitnami

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
