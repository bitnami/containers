FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 locales procps tar wget
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.292-0-linux-amd64-debian-10.tar.gz && \
    echo "700e2d8391934048faefb45b4c3a2af74bc7b85d4c4e0e9a24164d7256456ca2  /tmp/bitnami/pkg/cache/java-1.8.292-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.292-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.292-0-linux-amd64-debian-10.tar.gz
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/spring-cloud-skipper-shell-2.6.2-0-linux-amd64-debian-10.tar.gz && \
    echo "93ee06ced5c9a45a54823d59fa938f5bf0eca7353aff708208b119f80cd17a47  /tmp/bitnami/pkg/cache/spring-cloud-skipper-shell-2.6.2-0-linux-amd64-debian-10.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/spring-cloud-skipper-shell-2.6.2-0-linux-amd64-debian-10.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/spring-cloud-skipper-shell-2.6.2-0-linux-amd64-debian-10.tar.gz
RUN chmod g+rwX /opt/bitnami
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN touch /opt/bitnami/spring-cloud-skipper-shell/spring-cloud-skipper-shell.log && chmod -R g+rwX /opt/bitnami/spring-cloud-skipper-shell

COPY rootfs /
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
ENV BITNAMI_APP_NAME="spring-cloud-skipper-shell" \
    BITNAMI_IMAGE_VERSION="2.6.2-debian-10-r15" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    PATH="/opt/bitnami/java/bin:$PATH"

WORKDIR /opt/bitnami/spring-cloud-skipper-shell
USER 1001
ENTRYPOINT [ "/opt/bitnami/java/bin/java", "-jar", "/opt/bitnami/spring-cloud-skipper-shell/spring-cloud-skipper-shell.jar" ]
CMD [ "--help" ]
