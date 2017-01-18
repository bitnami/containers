FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=parse \
    BITNAMI_IMAGE_VERSION=2.3.2-r0 \
    PATH=/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:$PATH

# System packages required
RUN install_packages libc6 libssl1.0.0 libncurses5 libtinfo5 zlib1g libbz2-1.0 libreadline6 libstdc++6 libgcc1 ghostscript imagemagick libmysqlclient18

# Additional modules required
RUN bitnami-pkg install node-4.7.2-0 --checksum b814eaeeee872c8629432d3e950570ebc2d3dfcdd0db5b4cf8f763652b1981f1
RUN bitnami-pkg install mongodb-client-3.4.1-0 --checksum fcf8ccf8982420a91190ca3da61fb9d212e21dbdfea99afd8d17af9a266a4e6c

# Install parse
RUN bitnami-pkg unpack parse-2.3.2-0 --checksum b9e547f7ecf8cf3ece7ff96616e2983ba7ef2d18393150bddadc23ab030f454e

COPY rootfs /

VOLUME ["/bitnami/parse"]

EXPOSE 1337

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "parse"]
