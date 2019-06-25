FROM bitnami/minideb-extras-base:stretch-r283
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libffi6 libgcc1 libncurses5 libnss-wrapper libreadline7 libsqlite3-0 libssl1.1 libtinfo5 locales zlib1g
RUN . ./libcomponent.sh && component_unpack "python" "3.6.8-2" --checksum 2eb057ee7701667327f6bcc1fc8765abe5d9d003a64124e5f8505fa692e71eb8
RUN . ./libcomponent.sh && component_unpack "java" "1.8.212-0" --checksum 54a18672c8b4c1a44324c607a6bc616f614a062005d5e3384f91f10ff6f6edea
RUN . ./libcomponent.sh && component_unpack "spark" "2.4.3-0" --checksum c2042b8676d7559a9eccb68b6c1f13f33b054147cb07e65900e81e417f9557dc

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="spark" \
    BITNAMI_IMAGE_VERSION="2.4.3-debian-9-r11" \
    JAVA_HOME="/opt/bitnami/java" \
    NSS_WRAPPER_GROUP="/opt/bitnami/spark/tmp/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/spark/tmp/nss_passwd" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/spark/bin:/opt/bitnami/spark/sbin:$PATH" \
    SPARK_HOME="/opt/bitnami/spark"

WORKDIR /opt/bitnami/spark
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
