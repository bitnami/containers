FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV BITNAMI_PREFIX=/usr/local/bitnami
ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/mysql
ENV BITNAMI_APP_NAME mariadb
ENV BITNAMI_APP_USER mysql
ENV BITNAMI_APP_VERSION 5.5.42-0
ENV BITNAMI_APP_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME

# Specific Utility functions
COPY installer.run.sha256 /tmp/installer.run.sha256
COPY bitnami-utils-custom.sh /bitnami-utils-custom.sh
# General Utility functions
ADD https://www.dropbox.com/s/9rffufx3drjisl1/install.sh?dl=1 /tmp/install.sh

COPY post-install.sh /tmp/post-install.sh

# We need to specify a mysql password since the installer initializes the database, but it is
# removed in the post install and re-initialized at runtime.
RUN sh /tmp/install.sh\
    --base_password bitnami --mysql_password bitnami --mysql_allow_all_remote_connections 1 --disable-components common --mysql_init_data_dir 0

# Temporary, should be removed from installer
RUN rm -rf $BITNAMI_APP_DIR/data

ENV PATH $BITNAMI_APP_DIR/bin:$PATH
EXPOSE 3306
VOLUME ["$BITNAMI_APP_VOL_PREFIX/data", "$BITNAMI_APP_VOL_PREFIX/conf", "$BITNAMI_APP_VOL_PREFIX/logs"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld.bin"]
