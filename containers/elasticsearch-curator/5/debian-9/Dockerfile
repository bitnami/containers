FROM bitnami/minideb-extras:stretch-r494
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages ca-certificates libbz2-1.0 libc6 libffi6 libncurses5 libreadline7 libsqlite3-0 libssl1.1 libtinfo5 wget zlib1g
RUN bitnami-pkg install python-3.6.9-3 --checksum c4d4542cde9d0c0e5d0239491cdd91cacc68319679d9fab4088a994c9d40a7f6
RUN bitnami-pkg install elasticsearch-curator-5.8.1-0 --checksum c1a6475aa29b7a78fbe3b48a4ef2b80034a38a3192a6193d8c068d585dab15cd
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8

COPY rootfs /
ENV BITNAMI_APP_NAME="elasticsearch-curator" \
    BITNAMI_IMAGE_VERSION="5.8.1-debian-9-r50" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/elasticsearch-curator/bin:$PATH"

USER 1001
ENTRYPOINT [ "curator" ]
CMD [ "--help" ]
