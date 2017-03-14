FROM gcr.io/stacksmith-images/minideb:jessie-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=solr \
    BITNAMI_IMAGE_VERSION=6.3.0-r2 \
    PATH=/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH

# System packages required
RUN install_packages libc6 libxext6 libx11-6 libxcb1 libxau6 libxdmcp6 libglib2.0-0 libfreetype6 libfontconfig1 libstdc++6 libgcc1 zlib1g libselinux1 libpng12-0 libexpat1 libffi6 libpcre3 libxml2 liblzma5

# Additional modules required
RUN bitnami-pkg install java-1.8.0_111-1 --checksum f7705a3955f006eb59a6e4240a01d8273b17ba38428d30ffe7d10c9cc525d7be

# Install solr
RUN bitnami-pkg unpack solr-6.3.0-0 --checksum 380f620eb733b8609cbf7767d8ec61dd70b1da3bdc4698dc54d2aa52c3ff0f9e

COPY rootfs /

ENV APACHE_HTTP_PORT="80" \
    APACHE_HTTPS_PORT="443" \
    CODIAD_USERNAME="user" \
    CODIAD_PASSWORD="bitnami" \
    CODIAD_PROJECT_NAME="Sample Project" \
    CODIAD_PROJECT_PATH="sampleProject" \
    CODIAD_THEME="default" \
    CODIAD_HOST="127.0.0.1"

VOLUME ["/bitnami/solr"]

EXPOSE 8983

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami","start","--foreground","solr"]
