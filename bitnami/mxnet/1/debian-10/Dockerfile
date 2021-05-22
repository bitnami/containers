FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaec0 libaom0 libarmadillo9 libarpack2 libatk-bridge2.0-0 libatk1.0-0 libatomic1 libatspi2.0-0 libavcodec58 libavformat58 libavresample4 libavutil56 libblas3 libblkid1 libbluray2 libbsd0 libbz2-1.0 libc6 libcairo-gobject2 libcairo2 libcharls2 libchromaprint1 libcodec2-0.8.1 libcom-err2 libcroco3 libcrystalhd3 libcurl3-gnutls libdap25 libdapclient6v5 libdapserver7v5 libdatrie1 libdbus-1-3 libdc1394-22 libdrm2 libepoxy0 libepsilon1 libexif12 libexpat1 libffi6 libfontconfig1 libfreetype6 libfreexl1 libfribidi0 libfyba0 libgcc1 libgcrypt20 libgdal20 libgdcm2.8 libgdk-pixbuf2.0-0 libgeos-3.7.1 libgeos-c1v5 libgeotiff2 libgfortran5 libgif7 libglib2.0-0 libgme0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgphoto2-6 libgphoto2-port12 libgraphite2-3 libgsm1 libgssapi-krb5-2 libgtk-3-0 libharfbuzz0b libhdf4-0-alt libhdf5-103 libhogweed4 libicu63 libidn2-0 libilmbase23 libjbig0 libjpeg62-turbo libjson-c3 libk5crypto3 libkeyutils1 libkmlbase1 libkmlconvenience1 libkmldom1 libkmlengine1 libkmlregionator1 libkmlxsd1 libkrb5-3 libkrb5support0 liblapack-dev liblapack3 liblcms2-2 libldap-2.4-2 libltdl7 liblz4-1 liblzma5 libmariadb3 libminizip1 libmount1 libmp3lame0 libmpg123-0 libncursesw6 libnetcdf13 libnettle6 libnghttp2-14 libnorm1 libnspr4 libnss3 libnuma1 libodbc1 libogdi3.2 libogg0 libomp-dev libopencv-core3.2 libopencv-highgui-dev libopencv-highgui3.2 libopencv-imgcodecs3.2 libopencv-imgproc3.2 libopencv-videoio3.2 libopenexr23 libopenjp2-7 libopenmpt0 libopus0 libp11-kit0 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libpcre3 libpgm-5.2-0 libpixman-1-0 libpng16-16 libpoppler82 libpopt0 libpq5 libproj13 libprotobuf-dev libprotobuf17 libpsl5 libqhull7 libquadmath0 libraw1394-11 libreadline7 librsvg2-2 librtmp1 libsasl2-2 libselinux1 libshine3 libsnappy1v5 libsodium23 libsoxr0 libspatialite7 libspeex1 libsqlite3-0 libssh-gcrypt-4 libssh2-1 libssl1.1 libstdc++6 libsuperlu5 libswresample3 libswscale5 libsystemd0 libsz2 libtasn1-6 libtbb2 libthai0 libtheora0 libtiff5 libtinfo6 libtwolame0 libudev1 libunistring2 liburiparser1 libusb-1.0-0 libuuid1 libva-drm2 libva-x11-2 libva2 libvdpau1 libvorbis0a libvorbisenc2 libvorbisfile3 libvpx5 libwavpack1 libwayland-client0 libwayland-cursor0 libwayland-egl1 libwebp6 libwebpmux3 libx11-6 libx264-155 libx265-165 libxau6 libxcb-render0 libxcb-shm0 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxdmcp6 libxerces-c3.2 libxext6 libxfixes3 libxi6 libxinerama1 libxkbcommon0 libxml2 libxrandr2 libxrender1 libxvidcore4 libzmq3-dev libzmq5 libzstd1 libzvbi0 odbcinst1debian2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.7.10-5" --checksum 134f6de9ef375ef24749de63ae0290e9bedcf21ab97ca0386a052b544862b2d8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mxnet" "1.8.0-1" --checksum 2e1112666d6d174660ebf3582f920fb0b458e446e92fce1612148c4ad4a88a36
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/mxnet/postunpack.sh
ENV BITNAMI_APP_NAME="mxnet" \
    BITNAMI_IMAGE_VERSION="1.8.0-debian-10-r58" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mxnet/entrypoint.sh" ]
CMD [ "python" ]
