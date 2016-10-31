FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=osclass \
    BITNAMI_IMAGE_VERSION=3.6.1 \
    PATH=/opt/bitnami/php/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-8 --checksum 391deed983f7aaa04b4b47af59d8e8ced4f88076eff18d5405d196b6b270433c
RUN bitnami-pkg install php-7.0.12-1 --checksum d6e73b25677e4beae79c6536b1f7e6d9f23c153d62b586f16e334782a6868eb2
RUN bitnami-pkg install libphp-7.0.12-0 --checksum cf1a090ef79c2d1a7c9598a91e8dc7a485a5c3967aaee55cb08b23496fdbf1ee
RUN bitnami-pkg install mysql-client-10.1.18-0 --checksum f2f20e0512e7463996a6ad173156d249aa5ca746a1edb6c46449bd4d2736f725

# Install osclass
RUN bitnami-pkg unpack osclass-3.6.1-0 --checksum 0ba21b47d1bd2cb9d5988173e31d08fe046753d29ee2eded7dff72cb1c793c7a

COPY rootfs /

VOLUME ["/bitnami/osclass", "/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
