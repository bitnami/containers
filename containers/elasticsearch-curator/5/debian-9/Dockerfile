FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/elasticsearch-curator/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr gnupg libbz2-1.0 libc6 libffi6 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libtinfo5 locales procps sudo unzip wget zlib1g
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install python-3.6.10-0 --checksum 3d7e860761a828ac03c631386b6711433e07bd96d6184d73c11f59d6a7e3b480
RUN bitnami-pkg install elasticsearch-curator-5.8.1-0 --checksum c1a6475aa29b7a78fbe3b48a4ef2b80034a38a3192a6193d8c068d585dab15cd
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN /build/install-gosu.sh
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="elasticsearch-curator" \
    BITNAMI_IMAGE_VERSION="5.8.1-debian-9-r80" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami"

USER 1001
ENTRYPOINT [ "curator" ]
CMD [ "--help" ]
