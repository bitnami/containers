FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc-s1 locales procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.342-0-linux-amd64-debian-11.tar.gz && \
    echo "8f73ab6158f088f418caafcb5fd9981cf53076f38d8f9aba49acbcbadd6ac8da  /tmp/bitnami/pkg/cache/java-1.8.342-0-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.342-0-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.342-0-linux-amd64-debian-11.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/spring-cloud-dataflow-shell-2.9.4-152-linux-amd64-debian-11.tar.gz && \
    echo "0c5854a8016a60dcb95df2b294258df350275a35964743f317bcd06d99035528  /tmp/bitnami/pkg/cache/spring-cloud-dataflow-shell-2.9.4-152-linux-amd64-debian-11.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/spring-cloud-dataflow-shell-2.9.4-152-linux-amd64-debian-11.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/spring-cloud-dataflow-shell-2.9.4-152-linux-amd64-debian-11.tar.gz
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
ENV APP_VERSION="2.9.4" \
    BITNAMI_APP_NAME="spring-cloud-dataflow-shell" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/spring-cloud-dataflow-shell
USER 1001
ENTRYPOINT [ "/opt/bitnami/java/bin/java", "-jar", "/opt/bitnami/spring-cloud-dataflow-shell/spring-cloud-dataflow-shell.jar" ]
CMD [ "--help" ]
