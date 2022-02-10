FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig gzip libaudit1 libc6 libcap-ng0 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libxml2 procps tar xmlstarlet zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-4" --checksum 02f54928e3049660ccebfc9a6d348bfaf27c9eb5abf70ebad45962b88f38473d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tomcat" "9.0.58-5" --checksum 894430f154565fa3693964c0c321a21e8a976c97fcacb32f802420f19d0e3833
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.32-30" --checksum d60d87b07b9bddd4762dbbaa3e6096ccc66b854fd01a63c142c2fe17a6b67c64
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.1-0" --checksum 2566d89a20e9794698ad0868e8ea0b73cf27343d552c00c5278379c47aa62d29
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-6" --checksum 81b0642a6d8e9d952a0f6540f2d7481a99b9a12dd42bcb5906ba8014ca80f326
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "jasperreports" "7.8.1-2" --checksum 1323832c7470e3b7ca151857952a0c8ffba2d4a10d2e2c44aec7af8191e794f7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/tomcat/postunpack.sh
RUN /opt/bitnami/scripts/jasperreports/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV BITNAMI_APP_NAME="jasperreports" \
    BITNAMI_IMAGE_VERSION="7.8.1-debian-10-r68" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8009 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/jasperreports/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tomcat/run.sh" ]
