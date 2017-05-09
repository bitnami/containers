FROM bitnami/minideb-extras:jessie-r14

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=zookeeper \
    BITNAMI_IMAGE_VERSION=0.1-r0 \
    PATH=/opt/bitnami/zookeeper/bin:/opt/bitnami/java/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27

# Install zookeeper
RUN curl http://apache.org/dist/zookeeper/stable/zookeeper-3.4.10.tar.gz > /tmp/zookeeper.tgz
RUN mkdir -p /opt/bitnami/zookeeper && tar -vzxf /tmp/zookeeper.tgz --strip-components 1  -C /opt/bitnami/zookeeper
RUN install -d -m 0755 -o bitnami -g bitnami  /var/zookeeper



COPY rootfs /


EXPOSE 7000 7001 9042 9160

USER bitnami


CMD ["zkServer.sh", "start-foreground"]


