FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami/airflow/dags" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbsd0 libbz2-1.0 libc6 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 locales netbase procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-9" --checksum 4b509978f6d0a4c3b958deeb3490241cda60e4412c138da665192631d60f70de
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-33" --checksum 0649a1688896cf6ee9a9fd4d554ac33f364f498fca6d8be67a95f8111e7dad4f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "10.20.0-3" --checksum 90e96788ce3e47d1148f8fac65d14c6b8bfa084544a8cb983399537156dd2620
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.1-6" --checksum a947aad3f8cab0ff7c76506e1ea09156dfd442a6842500d1b8203f735b0e6b84
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.1-4" --checksum e5feed054f6c6e0497502e5c0551070241f543966491e962ce1f51780f6b170e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-6" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "airflow" "2.2.3-7" --checksum 60772a3e73e0fe8265ade7dca7086b79728cbf7942f167a99f3569336fa283b8
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
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
    BITNAMI_IMAGE_VERSION="2.2.3-debian-10-r60" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/airflow/venv/lib/python3.8/site-packages/numpy.libs/:$LD_LIBRARY_PATH" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="airflow" \
    NSS_WRAPPER_GROUP="/opt/bitnami/airflow/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/airflow/nss_passwd" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/python/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:/opt/bitnami/airflow/venv/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/airflow/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/airflow/run.sh" ]
