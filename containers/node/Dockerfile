FROM ubuntu-debootstrap:14.04

RUN apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get install -qy wget && \
    wget -q --no-check-certificate https://downloads.bitnami.com/files/download/nodejsstandalone/bitnami-nodejsstandalone-0.12.2-0-linux-x64-installer.run -O /tmp/installer.run && \
    chmod +x /tmp/installer.run && \
    /tmp/installer.run --mode unattended --prefix /opt/bitnami && \
    rm /opt/bitnami/ctlscript.sh /opt/bitnami/use_nodejsstandalone && \
    DEBIAN_FRONTEND=noninteractive apt-get --purge autoremove -qy wget && apt-get clean && rm -rf /var/lib/apt && rm -rf /var/cache/apt/archives/*

ENV PATH /opt/bitnami/python/bin:/opt/bitnami/nodejs/bin:/opt/bitnami/common/bin:$PATH

EXPOSE 80
VOLUME ["/app"]
WORKDIR "/app"

CMD ["node"]
