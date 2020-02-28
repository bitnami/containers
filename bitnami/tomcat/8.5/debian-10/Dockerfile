FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libssl1.1 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "11.0.6-0" --checksum f7446f8bec72b6b2606d37ba917accc243e6cd4e722700c39ef83832c46fb0c6
RUN . ./libcomponent.sh && component_unpack "tomcat" "8.5.51-1" --checksum 3dce07a7e34773d263e4bd1c5928fd2ca62502476b51009a0c9319781e9a955c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="8.5.51-debian-10-r16" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
