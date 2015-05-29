FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV APP_VERSION 1.8.0-0

RUN apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get install -qy wget && \
    wget -q --no-check-certificate https://downloads.bitnami.com/files/download/containers/nginxstandalonestack/bitnami-nginxstandalonestack-${APP_VERSION}-linux-x64-installer.run -O /tmp/installer.run && \
    chmod +x /tmp/installer.run && \
    /tmp/installer.run --mode unattended --prefix /opt/bitnami && \
    rm /opt/bitnami/ctlscript.sh /opt/bitnami/use_nginxstandalonestack && \
    DEBIAN_FRONTEND=noninteractive apt-get --purge autoremove -qy wget && apt-get clean && rm -rf /var/lib/apt && rm -rf /var/cache/apt/archives/*

ADD vhosts/* /opt/bitnami/nginx/conf/vhosts/

RUN echo "include "/opt/bitnami/nginx/conf/vhosts/*.conf";" > /opt/bitnami/nginx/conf/bitnami/bitnami-apps-vhosts.conf && \
    mv /opt/bitnami/nginx/conf /opt/bitnami/nginx/conf.defaults && \
    mv /opt/bitnami/nginx/html /opt/bitnami/nginx/html.defaults && \
    ln -s /opt/bitnami/nginx/conf/ /conf && \
    ln -s /opt/bitnami/nginx/logs/ /logs && \
    ln -s /opt/bitnami/nginx/html/ /app && \
    ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log && \
    ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log


ENV PATH /opt/bitnami/nginx/sbin:/opt/bitnami/common/bin:$PATH

EXPOSE 80 443
VOLUME ["/logs", "/conf", "/app"]

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
