FROM bitnami/oraclelinux-extras-base:7-r405
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc hostname zlib
RUN . ./libcomponent.sh && component_unpack "java" "11.0.4-0" --checksum 3a17c3d9c943fc8342a9aa9786e924627d5b5579163e957d0ca1c9de523626f3
RUN . ./libcomponent.sh && component_unpack "elasticsearch" "6.8.2-0" --checksum 6d762d7ea85afb71621e352456181e088536bae029eaae526b3ba0ba50cfc345

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="6.8.2-ol-7-r39" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
