# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

FROM redhat/ubi9:9.4

ARG EXTRA_LOCALES
ARG TARGETARCH
ARG WITH_ALL_LOCALES="no"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN dnf install -y tar gzip hostname wget sudo openssl openldap bzip2-libs libedit libffi gmp gnutls nettle libicu libidn2 openldap lz4 xz-libs p11-kit pcre readline cyrus-sasl-lib sqlite nss libtasn1 libunistring libxslt libzstd glibc-common procps-ng
RUN chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo
RUN sudo fips-mode-setup --enable --no-bootcfg
COPY openssl_fips.cnf .
RUN cp openssl_fips.cnf /etc/pki/tls/openssl_fips.cnf

RUN sudo dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-9-x86_64/pgdg-redhat-repo-latest.noarch.rpm
RUN sudo dnf install -y postgresql14-server
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
RUN /opt/bitnami/scripts/postgresql/postunpack.sh
RUN mkdir -p /opt/bitnami/postgresql/bin/ && chmod -R 777 /opt/bitnami/postgresql/bin
RUN cp -r /usr/pgsql-14/bin /opt/bitnami/postgresql/bin/
ENV APP_VERSION="14.12.0" \
    BITNAMI_APP_NAME="postgresql" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NSS_WRAPPER_LIB="/opt/bitnami/common/lib/libnss_wrapper.so" \
    PATH="/opt/bitnami/postgresql/bin:$PATH"

VOLUME [ "/bitnami/postgresql", "/docker-entrypoint-initdb.d", "/docker-entrypoint-preinitdb.d" ]

EXPOSE 5432

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/postgresql/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/postgresql/run.sh" ]

ENV OPENSSL_CONF=/etc/pki/tls/openssl_fips.cnf
ENV OPENSSL_FIPS=1
RUN openssl list -providers

# docker build --no-cache --progress=plain -t us-docker.pkg.dev/vorvan/dev/bitnami-postgresql14-ubi9:latest .
# docker push us-docker.pkg.dev/vorvan/dev/bitnami-postgresql14-ubi9:latest
