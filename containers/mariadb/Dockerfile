FROM ubuntu-debootstrap:14.04

RUN apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get install -qy wget && \
    wget -q --no-check-certificate https://downloads.bitnami.com/files/download/mariadb/bitnami-mariadb-5.5.42-0-linux-x64-installer.run -O /tmp/installer.run && \
    chmod +x /tmp/installer.run && \
    /tmp/installer.run --mode unattended --base_password bitnami --mysql_password bitnami --mysql_allow_all_remote_connections 1 --prefix /opt/bitnami --disable-components common && \
    /opt/bitnami/mysql/scripts/ctl.sh stop mysql > /dev/null && \
    echo "bin/mysql -S /opt/bitnami/mysql/tmp/mysql.sock -u root -p\$2 -e \"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '\$2' WITH GRANT OPTION;\"" >> /opt/bitnami/mysql/scripts/myscript.sh && \
    rm -rf /tmp/* /opt/bitnami/common /opt/bitnami/mysql/data /opt/bitnami/ctlscript.sh && \
    mkdir /data && chown mysql:mysql /data && \
    ln -s /data /opt/bitnami/mysql/data && \
    DEBIAN_FRONTEND=noninteractive apt-get --purge autoremove -qy wget && apt-get clean && rm -rf /var/lib/apt && rm -rf /var/cache/apt/archives/*

ENV PATH /opt/bitnami/mysql/bin:$PATH
EXPOSE 3306
VOLUME ["/data"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld.bin"]
