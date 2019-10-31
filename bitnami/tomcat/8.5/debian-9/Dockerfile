FROM bitnami/minideb-extras-base:stretch-r377
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "1.8.232-0" --checksum f4e5ff1d4fb13baf9bb2a4f2e5ffb328cf9eeb26d0b91214196e4473c2874adc
RUN . ./libcomponent.sh && component_unpack "tomcat" "8.5.47-0" --checksum a3d09c9afd9e5115311ec27dc5abb6f00bc73300b004b4497f14ffb2473d8c1d

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="8.5.47-debian-9-r14" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
