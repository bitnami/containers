FROM bitnami/minideb-extras:jessie-r21-buildpack

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages ghostscript imagemagick libc6 libffi6 libgcc1 libgmp-dev libmysqlclient18 libmysqlclient-dev libncurses5 libpq5 libreadline6 libssl1.0.0 libssl1.0.0 libstdc++6 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev netcat-traditional

RUN bitnami-pkg install ruby-2.4.1-1 --checksum 0b82f1457328b3c45daaa1adb89970087acac75f4d015a7e173906268877da02
RUN bitnami-pkg install mysql-client-10.1.26-0 --checksum 731e07b76a06c8b7f2a0b79d528f2f1f37e49142f682ab27ab8f4edfc9176d83

ENV PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:$PATH

# Ruby on Rails template
RUN gem install rails -v 5.1.4 --no-document

# Bundle the gems required for a new application
RUN rails new /tmp/temp_app --database mysql --quiet && rm -r /tmp/temp_app
RUN gem install therubyracer

ENV RAILS_ENV=development
ENV BITNAMI_APP_NAME=rails
ENV BITNAMI_IMAGE_VERSION=5.1.4-r0

COPY rootfs/ /

USER bitnami

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
