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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-5" --checksum 5bea54f21135133d1d0df7486e419d204f846d8acac4c83e1c6359a703fc9244
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tomcat" "9.0.58-6" --checksum 0811acd6e5598db328349579bcad45d18998bea7803cc5f4a93cd920d35a45a5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.32-31" --checksum 4489feca3a65fbd733774d193b02914187451c6edf27855ebc5756e45a9f299e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.1-1" --checksum d6e13f2b43164f885489658fbd8b95c9a006064d3389093712b179315dbf265d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-7" --checksum ed811d10882450d4755b893d5e034a0dd912cdb4f261dd332ddf6363411cc0ba
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "jasperreports" "7.8.1-31" --checksum 3ba71306ddde4dc0139de2c3726b8eacbfe105153e31b0c41c5d2c0bd27867b5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/tomcat/postunpack.sh
RUN /opt/bitnami/scripts/jasperreports/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV BITNAMI_APP_NAME="jasperreports" \
    BITNAMI_IMAGE_VERSION="7.8.1-debian-10-r69" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8009 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/jasperreports/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tomcat/run.sh" ]
