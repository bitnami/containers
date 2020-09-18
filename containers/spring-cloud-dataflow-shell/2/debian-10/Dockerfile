FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 locales procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.265-0-linux-amd64-debian-10.tar.gz && \
    echo "6c85e8df954fca444f2471195524db015ec24a67e42f43579401f2adb5189cb8  /tmp/bitnami/pkg/cache/java-1.8.265-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.265-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.265-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/spring-cloud-dataflow-shell-2.6.1-0-linux-amd64-debian-10.tar.gz && \
    echo "876ee5f1551564322b2877b1b9952b0461297a0a6557911c3bfd5688dee085cd  /tmp/bitnami/pkg/cache/spring-cloud-dataflow-shell-2.6.1-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/spring-cloud-dataflow-shell-2.6.1-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/spring-cloud-dataflow-shell-2.6.1-0-linux-amd64-debian-10.tar.gz
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
    BITNAMI_IMAGE_VERSION="2.6.1-debian-10-r28" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/spring-cloud-dataflow-shell
USER 1001
ENTRYPOINT [ "/opt/bitnami/java/bin/java", "-jar", "/opt/bitnami/spring-cloud-dataflow-shell/spring-cloud-dataflow-shell.jar" ]
CMD [ "--help" ]
