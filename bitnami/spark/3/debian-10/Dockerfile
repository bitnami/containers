FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/spark/bin:/opt/bitnami/spark/sbin:/opt/bitnami/common/bin:$PATH"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-33" --checksum 0649a1688896cf6ee9a9fd4d554ac33f364f498fca6d8be67a95f8111e7dad4f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-7" --checksum 3ce0c1dc975421abe79ffa5d459b4562802312f299a86576d1a169fe2d38f5d9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spark" "3.2.1-6" --checksum 16d5e371a0e2106d9319ad0160c4c2a0b05b6103e8296ffeac481db74030c541
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-6" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/spark/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="spark" \
    BITNAMI_IMAGE_VERSION="3.2.1-debian-10-r20" \
    JAVA_HOME="/opt/bitnami/java" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/spark/venv/lib/python3.8/site-packages/numpy.libs/:$LD_LIBRARY_PATH" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    NSS_WRAPPER_GROUP="/opt/bitnami/spark/tmp/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/spark/tmp/nss_passwd" \
    PYTHONPATH="/opt/bitnami/spark/python/:$PYTHONPATH" \
    SPARK_HOME="/opt/bitnami/spark"

WORKDIR /opt/bitnami/spark
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spark/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spark/run.sh" ]
