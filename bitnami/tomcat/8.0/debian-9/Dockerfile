FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libssl1.1 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "11.0.5-0" --checksum 9fc7502ca3c073e6ae7dd6cfa0c2da6b6c26caccbe41b6d7b5a9d26050ee54ff
RUN . ./libcomponent.sh && component_unpack "tomcat" "8.0.53-24" --checksum 1206b60d30cd2919ec0e39e3d69ae63a0efcc40765ce4a6356898962f89e5a7a
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="8.0.53-debian-9-r479" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
