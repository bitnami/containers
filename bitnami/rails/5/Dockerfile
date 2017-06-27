FROM bitnami/minideb-extras:jessie-r19-buildpack

MAINTAINER Bitnami <containers@bitnami.com>

# System packages required
RUN install_packages ghostscript imagemagick libc6 libffi6 libgcc1 libgmp-dev libmysqlclient18 libmysqlclient-dev libncurses5 libpq5 libreadline6 libssl1.0.0 libssl1.0.0 libstdc++6 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev netcat-traditional

RUN bitnami-pkg install ruby-2.4.1-0 --checksum eaf2341624588774f61e4aac4f53c437e98b1e97f6915ba6327d3ecdc6c2c3a2
RUN bitnami-pkg install mysql-client-10.1.23-1 --checksum 0be92fcc4f7fec93edfa7f788e2bbb87b5b3aac92dfdec159a10590345362512

ENV PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:$PATH

# Ruby on Rails template
RUN gem install rails -v 5.1.2 --no-document

# Bundle the gems required for a new application
RUN rails new /tmp/temp_app --database mysql --quiet && rm -r /tmp/temp_app
RUN gem install therubyracer

ENV RAILS_ENV=development
ENV BITNAMI_APP_NAME=rails
ENV BITNAMI_IMAGE_VERSION=5.1.2-r0

COPY rootfs/ /

USER bitnami

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
