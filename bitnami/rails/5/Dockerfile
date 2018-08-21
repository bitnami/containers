FROM bitnami/minideb-extras:stretch

LABEL maintainer "Bitnami <containers@bitnami.com>"

# System packages required
RUN install_packages build-essential git ghostscript imagemagick libc6 libffi6 libgcc1 libgmp-dev default-libmysqlclient-dev libncurses5 libpq5 libreadline-dev libssl1.0-dev libstdc++6 libtinfo5 libxml2-dev libxslt1-dev zlib1g zlib1g-dev netcat-traditional

RUN bitnami-pkg install ruby-2.5.1-0 --checksum 51f464f3a76f63ed04c05668236357de3a01a3eff9ecd64d3a1a1c697a85200d
RUN bitnami-pkg install mysql-client-10.1.35-0 --checksum 368b07877bfeecb697d036647a39cac0152c11543763ec1290dad783c36fdd36

ENV PATH=/opt/bitnami/ruby/bin:/opt/bitnami/mysql/bin:$PATH

# Ruby on Rails template
RUN gem install rails -v 5.2.1 --no-document

# Bundle the gems required for a new application
RUN rails new /tmp/temp_app --database mysql --quiet && rm -r /tmp/temp_app
RUN gem install therubyracer

ENV RAILS_ENV=development
ENV BITNAMI_APP_NAME=rails
ENV BITNAMI_IMAGE_VERSION=5.2.1

COPY rootfs/ /

USER bitnami

WORKDIR /app

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
