FROM gcr.io/stacksmith-images/minideb:jessie-r8
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.10.3-r0 \
    BITNAMI_APP_NAME=nginx \
    BITNAMI_APP_USER=daemon

# System packages required
RUN install_packages libc6 libpcre3 libssl1.0.0 zlib1g

# Install nginx
RUN bitnami-pkg unpack nginx-1.10.3-0 --checksum f55a7ac4e3ce28c59596e2bdc21531b8cc7c5991cc84768be804534017db7c9f
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/html /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "nginx"]

WORKDIR /app

EXPOSE 80 443
