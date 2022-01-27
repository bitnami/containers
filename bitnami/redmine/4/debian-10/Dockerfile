FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gsfonts gzip imagemagick libaudit1 libbsd0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxml2-dev libxslt1-dev libxslt1.1 procps sqlite3 tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.17.2-2" --checksum d4477fb9d29cf2cf450dcfc09da4db214d3435b6f4412b139bdddfbb20e8252d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.9-5" --checksum 6dc3a30ecaa164f3e71beaafecce4e3f32c2e104a0323bc20310b64bab2c1c43
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.14.0-4" --checksum 14eda4cc9b632928555461c32babf4474eb41884b7a4fcc04bac27e23eb7887a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.4.22-1" --checksum 37ba718ad68506a9ea0705c12f013a6afc7210c82460769ffba0f16759caae95
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.35.0-0" --checksum 51075db42727d7b14b9941e7d7c063a135e9ad60cc606676d6e817e7d4a607b9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redmine" "4.2.3-3" --checksum 86cf34defd685fe04ad767567bd4a09cd92db91991af1e30ddfe19eaa5ea7e3a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/redmine/postunpack.sh
ENV BITNAMI_APP_NAME="redmine" \
    BITNAMI_IMAGE_VERSION="4.2.3-debian-10-r100" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/redmine/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/redmine/run.sh" ]
