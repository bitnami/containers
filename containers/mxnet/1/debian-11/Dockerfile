FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaec0 libaom0 libarmadillo10 libarpack2 libblas3 libbrotli1 libbsd0 libbz2-1.0 libc6 libcfitsio9 libcharls2 libcom-err2 libcrypt1 libcurl3-gnutls libdap27 libdapclient6v5 libdav1d4 libde265-0 libdeflate0 libepsilon1 libexpat1 libffi7 libfontconfig1 libfreetype6 libfreexl1 libfyba0 libgcc-s1 libgcrypt20 libgdal28 libgdcm3.0 libgeos-3.9.0 libgeos-c1v5 libgeotiff5 libgfortran5 libgif7 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhdf4-0-alt libhdf5-103-1 libhdf5-hl-100 libheif1 libhogweed6 libicu67 libidn2-0 libilmbase25 libjbig0 libjpeg62-turbo libjson-c5 libk5crypto3 libkeyutils1 libkmlbase1 libkmldom1 libkmlengine1 libkrb5-3 libkrb5support0 liblapack-dev liblapack3 liblcms2-2 libldap-2.4-2 libltdl7 liblzma5 libmariadb3 libmd0 libminizip1 libncursesw6 libnetcdf18 libnettle8 libnghttp2-14 libnorm1 libnsl2 libnspr4 libnss3 libnuma1 libodbc1 libogdi4.1 libomp-dev libopencv-core4.5 libopencv-highgui-dev libopencv-imgcodecs4.5 libopencv-imgproc4.5 libopenexr25 libopenjp2-7 libp11-kit0 libpcre3 libpgm-5.3-0 libpng16-16 libpoppler102 libpq5 libproj19 libprotobuf-dev libprotobuf23 libpsl5 libqhull8.0 libquadmath0 libreadline8 librtmp1 librttopo1 libsasl2-2 libsodium23 libspatialite7 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsuperlu5 libsz2 libtasn1-6 libtbb2 libtiff5 libtinfo6 libtirpc3 libunistring2 liburiparser1 libuuid1 libwebp6 libx265-192 libxerces-c3.2 libxml2 libzmq3-dev libzmq5 libzstd1 odbcinst1debian2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-1" --checksum 79af9dcbaa89c4047d2d24b4a4c2ae17b771fe94972734379b9e50ef3dec3442
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mxnet" "1.9.1-1" --checksum 32f5fb445a875ff9d3d7f29c99a648d07972a130165b39d512f11f22e739257c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

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
