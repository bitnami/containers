FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig gzip libc6 libcom-err2 libcurl4 libffi6 libfontconfig1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 openssh-client procps tar unzip zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-0" --checksum af5ec81cfb8e8420fe6af80a77d40da25e0f7e136abb6dde27267c97fb27cf8b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-0" --checksum 255bc547614ce8052f416a74c58cfb916f724876315f15b816e0eb98b2bded35
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.36.1-0" --checksum e00f740b66faf2808cb8983a39b186d43a8367730512c402df78751a9cefbfc1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "jenkins" "2.332.3-0" --checksum 6a129eefef0224c9e946e7425d98ad6c02f63f64b26d69b5fd34b03b08d95ad1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/jenkins/postunpack.sh
ENV APP_VERSION="2.332.3" \
    BITNAMI_APP_NAME="jenkins" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 8080 8443 50000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/jenkins/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/jenkins/run.sh" ]
