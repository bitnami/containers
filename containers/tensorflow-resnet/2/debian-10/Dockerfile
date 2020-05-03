FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/tensorflow-resnet/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr gnupg libc6 libgcc1 libstdc++6 procps sudo unzip
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install tini-0.19.0-0 --checksum 9a8ae20be31a518f042fcec359f2cf35bfdb4e2a56f2fa8ff9ef2ecaf45da80c
RUN bitnami-pkg unpack tensorflow-resnet-2.1.0-1 --checksum d4381ba897bbee4205ae3de6aa1554ad14204426c7ed08c1f621ab57b2ac6be5
RUN bitnami-pkg install gosu-1.12.0-0 --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN echo "deb http://http.us.debian.org/debian testing main non-free contrib" >> /etc/apt/sources.list && apt update && apt remove gcc-6 -y && install_packages gcc-7 libstdc++6

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-resnet" \
    BITNAMI_IMAGE_VERSION="2.1.0-debian-10-r94" \
    NAMI_PREFIX="/.nami"

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "tail", "-f", "/dev/null" ]
