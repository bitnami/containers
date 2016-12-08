FROM gcr.io/stacksmith-images/minideb:jessie-r5
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.10.2-r3 \
    BITNAMI_APP_NAME=nginx \
    BITNAMI_APP_USER=daemon

# System packages required
RUN install_packages --no-install-recommends libc6 libpcre3 libssl1.0.0 zlib1g

# Install nginx
RUN bitnami-pkg unpack nginx-1.10.2-1 --checksum 366b92b7629a7a19090256f6097563e241aa743b42f1f0ce902709acf4e4e491
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/html /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/common/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "nginx"]

WORKDIR /app

EXPOSE 80 443
