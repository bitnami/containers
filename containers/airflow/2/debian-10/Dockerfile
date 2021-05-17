FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/airflow/dags" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbsd0 libbz2-1.0 libc6 libcom-err2 libedit2 libffi6 libgcc1 libgmp10 libgnutls30 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncursesw6 libnettle6 libp11-kit0 libreadline7 libsasl2-2 libsqlite3-0 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 locales netbase procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-3" --checksum 7521d9a4f9e4e182bf32977e234026caa7b03759799868335bccb1edd8f8fd12
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.10-2" --checksum b7a37a0590eff13717c191c90dc277f26706196c5fbf2a6b79019bd9f1032f68
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "10.17.0-0" --checksum b1c2a23c7d904b8968f8264dbbe0816cb1d6f5475cce3da620f823752c129266
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.3.0-2" --checksum d89528e5d733f34ae030984584659ff10a36370d40332bd8d41c047764d39cda
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "airflow" "2.0.2-0" --checksum 3e17197854fd63215cef17296619809f92aad1d5f65f11826c58f40ce8cc914c
RUN chmod g+rwX /opt/bitnami
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /opt/bitnami/scripts/airflow/postunpack.sh
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
ENV AIRFLOW_HOME="/opt/bitnami/airflow" \
    BITNAMI_APP_NAME="airflow" \
    BITNAMI_IMAGE_VERSION="2.0.2-debian-10-r13" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/airflow/venv/lib/python3.8/site-packages/numpy.libs/:$LD_LIBRARY_PATH" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="airflow" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss_passwd" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/airflow/venv/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/airflow/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/airflow/run.sh" ]
