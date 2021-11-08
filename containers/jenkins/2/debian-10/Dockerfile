FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig gzip libc6 libcom-err2 libcurl4 libffi6 libfontconfig1 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 openssh-client procps tar unzip zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-1" --checksum 00722b62c7561929e039877a6e445a4bb782c340890c0a090fdae3c9e1960161
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.312-0" --checksum a7e034898281dff05591e74de285ecd69899ddaaff4ce1ea9c09556ac89c9c72
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.33.0-0" --checksum fd9a3245580fef6248f778efeba0a017675424f15ff16ace42c095496e4f02f3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "jenkins" "2.303.3-0" --checksum a8aa6fa77c220321e91cb0d07a162e148093ead584cc3f9d5cf8fe13db49fa38
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/jenkins/postunpack.sh
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.303.3-debian-10-r3" \
    JAVA_HOME="/opt/bitnami/java" \
    LD_PRELOAD="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="jenkins" \
    NSS_WRAPPER_GROUP="/opt/bitnami/jenkins/nss-wrapper/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/jenkins/nss-wrapper/nss_passwd" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 8080 8443 50000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/jenkins/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/jenkins/run.sh" ]
