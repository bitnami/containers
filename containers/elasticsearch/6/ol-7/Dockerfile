FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio-devel procps-ng sudo tar which zlib
RUN . ./libcomponent.sh && component_unpack "java" "11.0.6-0" --checksum 44f5ec63dbe8d2ea9aaea237cec2d8821ac3ee6fa2812c295c0fa04068d0e08e
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "6.8.6-0" --checksum 36d259ed9c8fca470cfc22134ca1268f7168e072467ed2f3e7d75ea5dc1f2313
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN curl --silent -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 > /usr/local/bin/yq && echo 99a01ae32f0704773c72103adb7050ef5c5cad14b517a8612543821ef32d6cc9 /usr/local/bin/yq | sha256sum --check && chmod +x /usr/local/bin/yq && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/mikefarah/yq/master/LICENSE > /opt/bitnami/licenses/yq-2.4.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.8.6-ol-7-r43" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
