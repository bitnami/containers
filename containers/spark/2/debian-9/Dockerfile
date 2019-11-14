FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libbz2-1.0 libc6 libffi6 libgcc1 libncurses5 libnss-wrapper libreadline7 libsqlite3-0 libssl1.1 libtinfo5 locales zlib1g
RUN . ./libcomponent.sh && component_unpack "python" "3.6.9-2" --checksum 7ed6019242d0e6928c6cb314e554d929970f6bbaa0b4c6c2f8631d4cf5f31f3b
RUN . ./libcomponent.sh && component_unpack "java" "1.8.232-0" --checksum f4e5ff1d4fb13baf9bb2a4f2e5ffb328cf9eeb26d0b91214196e4473c2874adc
RUN . ./libcomponent.sh && component_unpack "spark" "2.4.4-1" --checksum c1cd12976aea9700ffb19413f478946982bcd0e350b71729c914813dd0671440

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="spark" \
    BITNAMI_IMAGE_VERSION="2.4.4-debian-9-r56" \
    JAVA_HOME="/opt/bitnami/java" \
    NSS_WRAPPER_GROUP="/opt/bitnami/spark/tmp/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/spark/tmp/nss_passwd" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/spark/bin:/opt/bitnami/spark/sbin:$PATH" \
    SPARK_HOME="/opt/bitnami/spark"

WORKDIR /opt/bitnami/spark
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
