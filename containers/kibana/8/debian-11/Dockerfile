FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kibana/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libexpat1 libgcc-s1 libnss3 libstdc++6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.25.2-0" --checksum 58fc2dcc9eda8b5e88ef23081c14384a33ac4736d7238d490416fb4c5c633994
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kibana" "8.2.2-0" --checksum 3be7be8dc02df3004a59638347098ede60d28b4d4b0f9b61ec30e09d46892f47
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/kibana/postunpack.sh
ENV APP_VERSION="8.2.2" \
    BITNAMI_APP_NAME="kibana"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kibana/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kibana/run.sh" ]
