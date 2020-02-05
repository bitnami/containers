FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio-devel procps-ng sudo tar which
RUN . ./libcomponent.sh && component_unpack "harbor-jobservice" "1.10.0-0" --checksum 4076edd0817254afb400f2d73783c3a2b5cd1c360785a1b209c5acab7148d0af
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN curl --silent -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 > /usr/local/bin/yq && echo 99a01ae32f0704773c72103adb7050ef5c5cad14b517a8612543821ef32d6cc9 /usr/local/bin/yq | sha256sum --check && chmod +x /usr/local/bin/yq && mkdir -p /opt/bitnami/licenses && curl --silent -L https://raw.githubusercontent.com/mikefarah/yq/master/LICENSE > /opt/bitnami/licenses/yq-2.4.0.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-jobservice" \
    BITNAMI_IMAGE_VERSION="1.10.0-ol-7-r50" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-jobservice/bin:$PATH"

VOLUME [ "/etc/jobservice", "/var/log/jobs/" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
