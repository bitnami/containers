FROM bitnami/minideb-extras-base:stretch-r370
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-1" --checksum 373c9f3d2943b9ff653fc0e7c69b1d54a75807726691a09190648808500b8253
RUN . ./libcomponent.sh && component_unpack "tomcat" "8.5.46-0" --checksum e976797f9cb1345ad96211855882d03805607f52dec45754a34c8d5eaaa6f6f8

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="8.5.46-debian-9-r2" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
