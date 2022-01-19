FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gzip imagemagick libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libxml2 libxml2-dev libxslt1-dev procps sqlite3 sudo tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-12" --checksum c081f7f9663d4d64e7f26d6e6a77b3860ee1f39c309bd564f801c39192042d2f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.7.5-2" --checksum a08fd87126902d0fa32351fc40378bda8259aeb0587d1b6040e73df83d2130c0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.18.3-4" --checksum db22b165d55c532af7af883535bf9f2dc2c0f6c7fcd86358be93e04e8b537fa0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.32-1" --checksum 727834a55587746f90b159966c9abf2ce31a6effbe83d8c38ee6250641c9a22a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.34.1-1" --checksum 424d40a4b5af1fcddbfd407ac97543378864d1b4539064ceef428e526bfd4f0e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-5" --checksum 1e34030c18f0ec2467fa5f1b1fbad24add217f671c3a61628f7b8671391f9676
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "rails" "7.0.1-0-0" --checksum e417762b51a7172667a5f77112989fb959d4c0ce9016a5cc1198e4bd9e1976fc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-1" --checksum 16f1a317859b06ae82e816b30f98f28b4707d18fe6cc3881bff535192a7715dc
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN /opt/bitnami/scripts/rails/postunpack.sh
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="7.0.1-0-debian-10-r6" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/rails/entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
