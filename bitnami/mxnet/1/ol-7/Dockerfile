FROM bitnami/oraclelinux-extras-base:7-r351
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages OpenEXR-libs atk blas bzip2-libs cairo expat fontconfig freetype fribidi gdk-pixbuf2 glib2 glibc graphite2 gstreamer gstreamer-plugins-base gtk2 harfbuzz ilmbase jasper-libs jbigkit-libs keyutils-libs krb5-libs lapack lapack-devel libX11 libXau libXcomposite libXcursor libXdamage libXext libXfixes libXi libXinerama libXrandr libXrender libblkid libcom_err libffi libgcc libgfortran libglvnd libglvnd-egl libglvnd-glx libgomp libjpeg-turbo libmount libopm-devel libpng libquadmath libselinux libsodium libstdc++ libthai libtiff libuuid libv4l libxcb libxml2 ncurses-libs nss-softokn-freebl opencv opencv-core opencv-devel openpgm openssl-libs orc pango pcre pixman protobuf protobuf-devel readline sqlite xz-libs zeromq zeromq-devel zlib
RUN . ./libcomponent.sh && component_unpack "python" "3.6.9-0" --checksum 5235f5ce54a979602fb01ab571f612a9ee966519bc22053214d1aeaaf376a0bd
RUN . ./libcomponent.sh && component_unpack "mxnet" "1.4.1-0" --checksum a49753b33a2c26b5d94c607a7e1a2fbca495459d6ed6582fd66dd6d076edc99b

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="mxnet" \
    BITNAMI_IMAGE_VERSION="1.4.1-ol-7-r51" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
