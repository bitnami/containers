FROM bitnami/minideb-extras-base:stretch-r368
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libffi6 libgcc1 libncurses5 libnss-wrapper libreadline7 libsqlite3-0 libssl1.1 libtinfo5 locales zlib1g
RUN . ./libcomponent.sh && component_unpack "python" "3.6.9-1" --checksum 16bf895318d5581937b3b5e73b55d7c7180a8ef42af8d0a8d4dd010bd0a0408d
RUN . ./libcomponent.sh && component_unpack "java" "1.8.222-1" --checksum 373c9f3d2943b9ff653fc0e7c69b1d54a75807726691a09190648808500b8253
RUN . ./libcomponent.sh && component_unpack "spark" "2.4.4-1" --checksum c1cd12976aea9700ffb19413f478946982bcd0e350b71729c914813dd0671440

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="spark" \
    BITNAMI_IMAGE_VERSION="2.4.4-debian-9-r19" \
    JAVA_HOME="/opt/bitnami/java" \
    NSS_WRAPPER_GROUP="/opt/bitnami/spark/tmp/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/spark/tmp/nss_passwd" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/spark/bin:/opt/bitnami/spark/sbin:$PATH" \
    SPARK_HOME="/opt/bitnami/spark"

WORKDIR /opt/bitnami/spark
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
