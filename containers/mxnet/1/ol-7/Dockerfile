FROM bitnami/oraclelinux-extras-base:7-r327
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages OpenEXR-libs atk blas bzip2-libs cairo expat fontconfig freetype fribidi gdk-pixbuf2 glib2 glibc graphite2 gstreamer gstreamer-plugins-base gtk2 harfbuzz ilmbase jasper-libs jbigkit-libs keyutils-libs krb5-libs lapack lapack-devel libX11 libXau libXcomposite libXcursor libXdamage libXext libXfixes libXi libXinerama libXrandr libXrender libblkid libcom_err libffi libgcc libgfortran libglvnd libglvnd-egl libglvnd-glx libgomp libjpeg-turbo libmount libopm-devel libpng libquadmath libselinux libsodium libstdc++ libthai libtiff libuuid libv4l libxcb libxml2 ncurses-libs nss-softokn-freebl opencv opencv-core opencv-devel openpgm openssl-libs orc pango pcre pixman protobuf protobuf-devel readline sqlite xz-libs zeromq zeromq-devel zlib
RUN . ./libcomponent.sh && component_unpack "python" "3.6.8-2" --checksum ef147d69b97d735e099fe281f6e7270ad9d5101eb2a4aca364525b1776b2e6ae
RUN . ./libcomponent.sh && component_unpack "mxnet" "1.4.1-0" --checksum a49753b33a2c26b5d94c607a7e1a2fbca495459d6ed6582fd66dd6d076edc99b

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="mxnet" \
    BITNAMI_IMAGE_VERSION="1.4.1-ol-7-r27" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
