FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/airflow/dags" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbsd0 libbz2-1.0 libc6 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 netbase procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-5" --checksum 1e34030c18f0ec2467fa5f1b1fbad24add217f671c3a61628f7b8671391f9676
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-12" --checksum c081f7f9663d4d64e7f26d6e6a77b3860ee1f39c309bd564f801c39192042d2f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "10.19.0-1" --checksum 53e64e567d4563efaea05f4e9e9eead3a3fbec1213a05528a5eeec2d2f8e8a43
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.1-3" --checksum 26f2ba99a02266d6f3857a3a11db7ed441d76a2fbc1066a17d4b0b17b047e01d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.34.1-4" --checksum 3cb223b1dbe1be9280279e2427c850f7080bf6d0b938c2fbe7b2d7a34724c61b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "airflow-scheduler" "2.2.3-3" --checksum bf6563a4e9bc65802695081935b653b3f94712bb5f5c41218528f9697e668fd1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/airflow-scheduler/postunpack.sh
ENV AIRFLOW_HOME="/opt/bitnami/airflow" \
    BITNAMI_APP_NAME="airflow-scheduler" \
    BITNAMI_IMAGE_VERSION="2.2.3-debian-10-r32" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/airflow/venv/lib/python3.8/site-packages/numpy.libs/:$LD_LIBRARY_PATH" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="airflow" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss_passwd" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:/opt/bitnami/airflow/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/airflow-scheduler/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/airflow-scheduler/run.sh" ]
