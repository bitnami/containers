FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libatk1.0-0 libatomic1 libavcodec57 libavformat57 libavutil55 libblas3 libblkid1 libbluray1 libbsd0 libbz2-1.0 libc6 libcairo2 libchromaprint1 libcomerr2 libcrystalhd3 libdatrie1 libdc1394-22 libdrm2 libexpat1 libffi6 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libgdk-pixbuf2.0-0 libgfortran3 libglib2.0-0 libgme0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgraphite2-3 libgsm1 libgssapi-krb5-2 libgtk2.0-0 libharfbuzz0b libhogweed4 libicu57 libidn11 libilmbase12 libjbig0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblapack-dev liblapack3 liblzma5 libmount1 libmp3lame0 libmpg123-0 libncurses5 libnettle6 libnuma1 libogg0 libomp-dev libopencv-core2.4v5 libopencv-highgui-dev libopencv-highgui2.4-deb0 libopencv-imgproc2.4v5 libopenexr22 libopenjp2-7 libopenmpt0 libopus0 libp11-kit0 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libpcre3 libpgm-5.2-0 libpixman-1-0 libpng16-16 libprotobuf-dev libprotobuf10 libquadmath0 libraw1394-11 libreadline7 libselinux1 libshine3 libsnappy1v5 libsodium18 libsoxr0 libspeex1 libsqlite3-0 libssh-gcrypt-4 libssl1.1 libstdc++6 libswresample2 libswscale4 libtasn1-6 libtbb2 libthai0 libtheora0 libtiff5 libtinfo5 libtwolame0 libudev1 libusb-1.0-0 libuuid1 libv4l-0 libv4lconvert0 libva-drm1 libva-x11-1 libva1 libvdpau1 libvorbis0a libvorbisenc2 libvorbisfile3 libvpx4 libwavpack1 libwebp6 libwebpmux2 libx11-6 libx264-148 libx265-95 libxau6 libxcb-render0 libxcb-shm0 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxi6 libxinerama1 libxml2 libxrandr2 libxrender1 libxvidcore4 libzmq3-dev libzmq5 libzvbi0 procps unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "python" "3.6.10-0" --checksum 3d7e860761a828ac03c631386b6711433e07bd96d6184d73c11f59d6a7e3b480
RUN . ./libcomponent.sh && component_unpack "mxnet" "1.5.1-1" --checksum bf2a7e2231ec21021fe05629f22367b2919d10ca93556cb18b425a2a1ff24a9f
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="mxnet" \
    BITNAMI_IMAGE_VERSION="1.5.1-debian-9-r62" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/python/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
