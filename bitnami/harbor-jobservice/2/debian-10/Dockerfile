FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.13.2-0" --checksum 92356ab39f3233604478ffaf639429461d00a66d63ad42ec0a8d29f2bea43193
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-jobservice" "2.3.2-0" --checksum 67d25c80d8e77e60e74891683f4f905f0b4e14634d7cd7eb85da9cc42daeb649
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-jobservice/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-jobservice" \
    BITNAMI_IMAGE_VERSION="2.3.2-debian-10-r34" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/harbor-jobservice/bin:$PATH"

VOLUME [ "/etc/jobservice", "/var/log/jobs" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-jobservice/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-jobservice/run.sh" ]
