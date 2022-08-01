FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-158" --checksum 5e09dc3db2d81167c999fb6ef5391a2204b3a93a2e30581785728b7fdc427f8f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "12.22.12-152" --checksum 90d4e7c47a0b44636a194efb44d68b9122db8a02bd45aab0b8936e37af99c6b8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse-dashboard" "4.1.4-1" --checksum abc7c21a57666ce9623990a4ffcd1becffc1a7f95a0fc457beeb1f80ebd80dbe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse-dashboard/postunpack.sh
ENV APP_VERSION="4.1.4" \
    BITNAMI_APP_NAME="parse-dashboard" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/parse-dashboard/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000 4040

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse-dashboard/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse-dashboard/run.sh" ]
