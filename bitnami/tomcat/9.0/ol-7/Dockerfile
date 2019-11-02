FROM bitnami/oraclelinux-extras-base:7-r467
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc libgcc zlib
RUN . ./libcomponent.sh && component_unpack "java" "1.8.232-0" --checksum fbac74363c807fce14538c5f9a9232602adc7883c1c5936571c741625de2479e
RUN . ./libcomponent.sh && component_unpack "tomcat" "9.0.27-0" --checksum 488a8fcddcd600ae8c9f32bb55ed4cf6f25d35d1e960b1aecc2b6391b6a30319

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="9.0.27-ol-7-r20" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
