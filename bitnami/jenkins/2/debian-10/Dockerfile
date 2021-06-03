FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl fontconfig fonts-dejavu-extra gzip libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 openssh-client procps tar unzip zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.0-3" --checksum 8179ad1371c9a7d897fe3b1bf53bbe763f94edafef19acad2498dd48b3674efe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.292-0" --checksum 700e2d8391934048faefb45b4c3a2af74bc7b85d4c4e0e9a24164d7256456ca2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.31.1-1" --checksum 81233bbb8e724b9fcc0f451a61d5120fdc101a26b40bb82307eaa2b694cdd789
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "jenkins" "2.277.4-1" --checksum b7935311c60ec68ebfedc455db89cace0a59d2d73b95f65e6ae4ffd4acc64d00
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/jenkins/postunpack.sh
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.277.4-debian-10-r19" \
    LD_PRELOAD="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="jenkins" \
    NSS_WRAPPER_GROUP="/opt/bitnami/jenkins/nss-wrapper/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/jenkins/nss-wrapper/nss_passwd" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 8080 8443 50000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/jenkins/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/jenkins/run.sh" ]
