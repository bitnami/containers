FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 locales procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.322-1-linux-amd64-debian-10.tar.gz && \
    echo "064c0df11dedb32c3a3e13c1daac87085ed44ccd816898f11e7a2496ece5d9ee  /tmp/bitnami/pkg/cache/java-1.8.322-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.322-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.322-1-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/spring-cloud-dataflow-shell-2.9.2-1-linux-amd64-debian-10.tar.gz && \
    echo "307bebec25e0e389b2f644602dee89512ce5f810f090b11d302148a67783abe0  /tmp/bitnami/pkg/cache/spring-cloud-dataflow-shell-2.9.2-1-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/spring-cloud-dataflow-shell-2.9.2-1-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/spring-cloud-dataflow-shell-2.9.2-1-linux-amd64-debian-10.tar.gz
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN touch /opt/bitnami/spring-cloud-dataflow-shell/spring-cloud-dataflow-shell.log && chmod -R g+rwX /opt/bitnami/spring-cloud-dataflow-shell

COPY rootfs /
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
ENV BITNAMI_APP_NAME="spring-cloud-dataflow-shell" \
    BITNAMI_IMAGE_VERSION="2.9.2-debian-10-r4" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/spring-cloud-dataflow-shell
USER 1001
ENTRYPOINT [ "/opt/bitnami/java/bin/java", "-jar", "/opt/bitnami/spring-cloud-dataflow-shell/spring-cloud-dataflow-shell.jar" ]
CMD [ "--help" ]
