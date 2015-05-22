FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV BITNAMI_APP_NAME mariadb
ENV BITNAMI_APP_VERSION 5.5.42-0
ENV BITNAMI_APP_DIRNAME mysql

ADD install.sh /tmp/install.sh
ADD post-install.sh /tmp/post-install.sh

# We need to specify a mysql password since the installer initializes the database, but it is
# removed in the post install and re-initialized at runtime.
RUN bash /tmp/install.sh\
    --base_password bitnami --mysql_password bitnami --mysql_allow_all_remote_connections 1 --disable-components common

ENV PATH /opt/bitnami/mysql/bin:$PATH
EXPOSE 3306
VOLUME ["/data", "/conf", "/logs"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld.bin"]
