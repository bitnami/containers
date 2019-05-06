FROM bitnami/minideb-extras-base:stretch-r236
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libgomp1 libquadmath0 libstdc++6 libx11-6
RUN . ./libcomponent.sh && component_unpack "miniconda" "4.6.14-0" --checksum eeb559d3328bccff1cd7544a49e6bea6ed9d3cc3337b27432255e989e39b9de2
RUN . ./libcomponent.sh && component_unpack "pytorch" "1.1.0-0" --checksum 4c8c0dafaea8760cb2f5ab45ec244f4da87e2320205f888645ebf35ab2cede31

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.1.0-debian-9-r0" \
    LD_LIBRARY_PATH="/opt/bitnami/miniconda/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/miniconda/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
