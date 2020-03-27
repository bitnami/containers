FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/tensorflow-resnet/bin:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr gnupg libc6 libgcc1 libstdc++6 procps sudo unzip
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install tini-0.18.0-3 --checksum 1e9b72b6636c6a48397a18df2363b44461e87ad7f892c179a9115c7525ed9327
RUN bitnami-pkg unpack tensorflow-resnet-2.1.0-0 --checksum ada0c09b7f3e9c962b56689b5524a99d6d2a90475a0d4d48215f347e2a984807
RUN bitnami-pkg install gosu-1.11.0-3 --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN echo "deb http://http.us.debian.org/debian testing main non-free contrib" >> /etc/apt/sources.list && apt update && apt remove gcc-6 -y && install_packages gcc-7 libstdc++6

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-resnet" \
    BITNAMI_IMAGE_VERSION="2.1.0-debian-10-r51" \
    NAMI_PREFIX="/.nami"

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
