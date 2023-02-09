FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.9.1-debian-11-r75" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/mxnet" \
      org.opencontainers.image.title="mxnet" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.9.1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libaec0 libaom0 libarmadillo10 libarpack2 libblas3 libbrotli1 libbsd0 libbz2-1.0 libcfitsio9 libcharls2 libcom-err2 libcrypt1 libcurl3-gnutls libdap27 libdapclient6v5 libdav1d4 libde265-0 libdeflate0 libepsilon1 libexpat1 libffi7 libfontconfig1 libfreetype6 libfreexl1 libfyba0 libgcc-s1 libgcrypt20 libgdal28 libgdcm3.0 libgeos-3.9.0 libgeos-c1v5 libgeotiff5 libgfortran5 libgif7 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhdf4-0-alt libhdf5-103-1 libhdf5-hl-100 libheif1 libhogweed6 libicu67 libidn2-0 libilmbase25 libjbig0 libjpeg62-turbo libjson-c5 libk5crypto3 libkeyutils1 libkmlbase1 libkmldom1 libkmlengine1 libkrb5-3 libkrb5support0 liblapack-dev liblapack3 liblcms2-2 libldap-2.4-2 libltdl7 liblzma5 libmariadb3 libmd0 libminizip1 libncursesw6 libnetcdf18 libnettle8 libnghttp2-14 libnorm1 libnsl2 libnspr4 libnss3 libnuma1 libodbc1 libogdi4.1 libomp-dev libopencv-core4.5 libopencv-highgui-dev libopencv-imgcodecs4.5 libopencv-imgproc4.5 libopenexr25 libopenjp2-7 libp11-kit0 libpcre3 libpgm-5.3-0 libpng16-16 libpoppler102 libpq5 libproj19 libprotobuf-dev libprotobuf23 libpsl5 libqhull8.0 libquadmath0 libreadline8 librtmp1 librttopo1 libsasl2-2 libsodium23 libspatialite7 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsuperlu5 libsz2 libtasn1-6 libtbb2 libtiff5 libtinfo6 libtirpc3 libunistring2 liburiparser1 libuuid1 libwebp6 libx265-192 libxerces-c3.2 libxml2 libzmq3-dev libzmq5 libzstd1 odbcinst1debian2 procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "python-3.8.16-0-linux-${OS_ARCH}-debian-11" \
      "mxnet-1.9.1-156-linux-${OS_ARCH}-debian-11" \
      "gosu-1.16.0-0-linux-${OS_ARCH}-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.local && chmod g+rwX /.local

COPY rootfs /
RUN /opt/bitnami/scripts/mxnet/postunpack.sh
ENV APP_VERSION="1.9.1" \
    BITNAMI_APP_NAME="mxnet" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mxnet/entrypoint.sh" ]
CMD [ "python" ]
