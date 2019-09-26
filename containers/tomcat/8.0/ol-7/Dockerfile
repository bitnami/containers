FROM bitnami/oraclelinux-extras-base:7-r429
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc libgcc zlib
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-1" --checksum 664cacaa11342e877410b197d21343543c2987cd66f15d2adc32cc61eee48eaa
RUN . ./libcomponent.sh && component_unpack "tomcat" "8.0.53-23" --checksum 472914d1aba64fc8af159cbe9a02b32ba10e458af60d1a5309d9af1d730a2cfb

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="8.0.53-ol-7-r426" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
