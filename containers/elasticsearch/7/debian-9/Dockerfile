FROM bitnami/minideb-extras-base:stretch-r375
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libasound2-dev libc6 libfreetype6 libfreetype6-dev libgcc1 libx11-6 libxext6 libxi6 libxrender1 libxtst6 zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "11.0.4-1" --checksum 561cd1095eaca816109f92dcb5f68a53b788cfa6734782763350b980a4e5538a
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "7.4.0-0" --checksum a180c0504bd578f399821ca885d5b59c1a8ff8cf996ae10d49e8a60f3b904774

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="7.4.0-debian-9-r2" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
