FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages OpenEXR-libs atk blas bzip2-libs ca-certificates cairo curl expat fontconfig freetype fribidi gdk-pixbuf2 glib2 glibc graphite2 gstreamer gstreamer-plugins-base gtk2 gzip harfbuzz hostname ilmbase jasper-libs jbigkit-libs keyutils-libs krb5-libs lapack lapack-devel libX11 libXau libXcomposite libXcursor libXdamage libXext libXfixes libXi libXinerama libXrandr libXrender libaio-devel libblkid libcom_err libffi libgcc libgfortran libglvnd libglvnd-egl libglvnd-glx libgomp libjpeg-turbo libmount libopm-devel libpng libquadmath libselinux libsodium libstdc++ libthai libtiff libuuid libv4l libxcb libxml2 ncurses-libs nss-softokn-freebl opencv opencv-core opencv-devel openpgm openssl-libs orc pango pcre pixman procps-ng protobuf protobuf-devel readline sqlite sudo tar which xz-libs zeromq zeromq-devel zlib
RUN . ./libcomponent.sh && component_unpack "python" "3.6.10-0" --checksum 5a8e49832c587612e6b4afa4dfe4708dc2153263ec594006eb7972c3352773b3
RUN . ./libcomponent.sh && component_unpack "mxnet" "1.5.1-1" --checksum e79139b6ae994be285caad03462861d7a84fe24c970d7c40b08ea6643b39ab7f
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="mxnet" \
    BITNAMI_IMAGE_VERSION="1.5.1-ol-7-r116" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
