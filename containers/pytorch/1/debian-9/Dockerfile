FROM bitnami/minideb-extras-base:stretch-r376
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libgomp1 libquadmath0 libstdc++6 libx11-6
RUN . ./libcomponent.sh && component_unpack "miniconda" "4.7.12-0" --checksum 157031b65e6789cd9eecd6606b955864612cce39a57de04d3c0fe25e08f72bc6
RUN . ./libcomponent.sh && component_unpack "pytorch" "1.3.0-0" --checksum ca70b73529120af74f7e21fd5f0f17f86b82e00146cf7f260a005156dce8dd76

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="pytorch" \
    BITNAMI_IMAGE_VERSION="1.3.0-debian-9-r7" \
    LD_LIBRARY_PATH="/opt/bitnami/miniconda/lib/python3.7/site-packages/torch/lib/:/opt/bitnami/miniconda/lib/python3.7/site-packages/PIL/.libs/:$LD_LIBRARY_PATH" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/miniconda/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "python" ]
