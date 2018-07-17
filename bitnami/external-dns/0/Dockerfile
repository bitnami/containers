FROM bitnami/minideb:jessie as buildenv

RUN install_packages ca-certificates wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/external-dns-0.5.4-0-linux-x64-debian-8.tar.gz && \
    echo "ba94b2ab2ba6adbbc236a2ace3d35cd005e4fd59de6417fe32d03ffabcf4abef  /tmp/bitnami/pkg/cache/external-dns-0.5.4-0-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/external-dns-0.5.4-0-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/external-dns-0.5.4-0-linux-x64-debian-8.tar.gz

##################

FROM bitnami/minideb:jessie
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=buildenv /opt/bitnami/external-dns /opt/bitnami/external-dns
ENV BITNAMI_APP_NAME="external-dns" \
    BITNAMI_IMAGE_VERSION="0.5.4-debian-8-r0" \
    PATH="/opt/bitnami/external-dns/bin:$PATH"

RUN install_packages ca-certificates

EXPOSE 7979

WORKDIR /opt/bitnami/external-dns
USER 1001
ENTRYPOINT ["external-dns"]
