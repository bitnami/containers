FROM bitnami/minideb-extras-base:stretch-r369
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libgomp1 libquadmath0 libstdc++6 libx11-6
RUN . ./libcomponent.sh && component_unpack "miniconda" "4.7.10-0" --checksum 6de1a01e9776a87cd40f5b19f5735562413f8225d36f3907e286a79864bfb081
RUN . ./libcomponent.sh && component_unpack "pytorch" "1.2.0-0" --checksum 96bf156fa3fca36b7f1b46d5dd184d806568d1c696554481fec246771b4fe42f

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.2.0-debian-9-r50" \
    LD_LIBRARY_PATH="/opt/bitnami/miniconda/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/miniconda/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
