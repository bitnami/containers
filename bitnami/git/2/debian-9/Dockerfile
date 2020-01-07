FROM bitnami/minideb-extras:stretch-r494
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libcomerr2 libcurl3 libffi6 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libtasn1-6 libunistring0 ssh zlib1g
RUN bitnami-pkg install git-2.24.1-0 --checksum 0bd650ac89eff766d64b3d19145ba69873742b8a18815c2957e1fddf86e796ef

COPY rootfs /
ENV BITNAMI_APP_NAME="git" \
    BITNAMI_IMAGE_VERSION="2.24.1-debian-9-r22" \
    PATH="/opt/bitnami/git/bin:$PATH"

ENTRYPOINT [ "git" ]
CMD [ "--help" ]
