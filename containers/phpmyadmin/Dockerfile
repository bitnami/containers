FROM gcr.io/stacksmith-images/minideb:jessie-r7

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=phpmyadmin \
    BITNAMI_IMAGE_VERSION=4.6.4 \
    PATH=/opt/bitnami/php/bin:$PATH

# Additional modules required
RUN bitnami-pkg unpack apache-2.4.23-9 --checksum 25bf5b82662874c21b0c0614c057d06b4a8ec14d8a76181053b691a9dfbf7f94
RUN bitnami-pkg install libphp-5.6.27-0 --checksum f9039cc69834334187c9b55fc20bf3be818cd87a2088ced2732fead1d1bfb2d6
RUN bitnami-pkg unpack php-5.6.28-0 --checksum 703ee1e4aa2fb1d3739633972aadae0e6620bd6c4d8520cea08f5ba9bfa589f2

# Install phpmyadmin
RUN bitnami-pkg unpack phpmyadmin-4.6.4-0 --checksum 1c255238fcd51cb0828f27bb572ddbea1d6bb33a5deb52131e220d645f10c14d

COPY rootfs /

VOLUME ["/bitnami/apache", "/bitnami/php", "/bitnami/phpmyadmin"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami","start","--foreground","apache"]
