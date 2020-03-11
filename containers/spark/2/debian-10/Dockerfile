FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libnss-wrapper libreadline7 libsqlite3-0 libssl1.1 libtinfo6 locales procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "python" "3.6.10-2" --checksum be882f108902cced8b37d06093ae90f4cfbd8575043d65e0ada58cb50650d48c
RUN . ./libcomponent.sh && component_unpack "java" "1.8.242-0" --checksum 3a70f3d1c3cd9bc6ec581b2a10373a2b323c0b9af40402ce8d19aeb0b3d02400
RUN . ./libcomponent.sh && component_unpack "spark" "2.4.5-0" --checksum c771475b2cba1d2b4a511a121efe66bd4d3bde3183c03e22aa386b5dd053f140
RUN . ./libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root spark

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="spark" \
    BITNAMI_IMAGE_VERSION="2.4.5-debian-10-r32" \
    JAVA_HOME="/opt/bitnami/java" \
    NSS_WRAPPER_GROUP="/opt/bitnami/spark/tmp/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/spark/tmp/nss_passwd" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/spark/bin:/opt/bitnami/spark/sbin:/opt/bitnami/gosu/bin:$PATH" \
    SPARK_HOME="/opt/bitnami/spark"

WORKDIR /opt/bitnami/spark
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
