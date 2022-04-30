FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbsd0 libc6 libedit2 libffi6 libgcc1 libgmp10 libgnutls30 libhogweed4 libicu63 libidn2-0 libldap-2.4-2 liblzma5 libnettle6 libp11-kit0 libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxslt1.1 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.6.0-5" --checksum ef8f465e059e386aa96e44ba6787ed68ba4bd80c8e73681672b760c8d3114bff
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-0" --checksum 255bc547614ce8052f416a74c58cfb916f724876315f15b816e0eb98b2bded35
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "sonarqube" "8.9.8-0" --checksum 7b39c94b53791494a3e131e3d394963e6f38edbdf05494f1e7803430c48c6754
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/sonarqube/postunpack.sh
ENV APP_VERSION="8.9.8" \
    BITNAMI_APP_NAME="sonarqube" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/postgresql/bin:/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 9000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/sonarqube/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/sonarqube/run.sh" ]
