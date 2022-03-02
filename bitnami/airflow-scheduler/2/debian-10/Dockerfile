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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-9" --checksum 4b509978f6d0a4c3b958deeb3490241cda60e4412c138da665192631d60f70de
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-37" --checksum 3272da2099afdae735a7d3fb199e83f3bd74b44ebf6953e2f9a3dd0ad45091d1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "10.20.0-4" --checksum 351886297b1300f9430bed82c58a9ec4c35101de73ee9bf8bb33b3c7fff76801
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.1-7" --checksum 7a4f45cbebd2e242278060415dd1a3f0dbe68991fdcaea5bb311e8de54a3e027
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.1-5" --checksum da12ba7cebb03c4eb983ba2248daf0ed5399be1bd8fa9d2d3931614ce6079ff6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "airflow-scheduler" "2.2.4-1" --checksum 1142844b4152f7b19b9e7cb9584b3e1c1b3ceb0f70e41836d7717fe74e8363b8
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/airflow-scheduler/postunpack.sh
ENV AIRFLOW_HOME="/opt/bitnami/airflow" \
    BITNAMI_APP_NAME="airflow-scheduler" \
    BITNAMI_IMAGE_VERSION="2.2.4-debian-10-r7" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/airflow/venv/lib/python3.8/site-packages/numpy.libs/:$LD_LIBRARY_PATH" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="airflow" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss_passwd" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:/opt/bitnami/airflow/venv/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/airflow-scheduler/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/airflow-scheduler/run.sh" ]
