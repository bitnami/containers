FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libblkid1 libbsd0 libc6 libffi6 libgcc1 libglib2.0-0 libmount1 libpcre3 libselinux1 libstdc++6 libuuid1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/java-1.8.181-1-linux-amd64-debian-9.tar.gz && \
    echo "66bba4b4a2647f981339d306da796905c222057c4277a5ef045e079981a404f4  /tmp/bitnami/pkg/cache/java-1.8.181-1-linux-amd64-debian-9.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/java-1.8.181-1-linux-amd64-debian-9.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/java-1.8.181-1-linux-amd64-debian-9.tar.gz

ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="1.8.181-debian-9-r12" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:$PATH"

CMD ["bash"]
