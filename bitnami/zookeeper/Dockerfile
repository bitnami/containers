FROM bitnami/minideb-extras:jessie-r15

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=zookeeper \
    BITNAMI_IMAGE_VERSION=0.1-r0 \
    ZOOKEEPER_VERSION=3.4.10 \
    PATH=/opt/bitnami/zookeeper/bin:/opt/bitnami/java/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27

# Install zookeeper
RUN curl -O  http://apache.org/dist/zookeeper/stable/zookeeper-${ZOOKEEPER_VERSION}.tar.gz 

RUN mkdir -p /opt/bitnami/zookeeper /var/zookeeper  && \
    tar -vzxf /zookeeper-${ZOOKEEPER_VERSION}.tar.gz --strip-components 1  -C /opt/bitnami/zookeeper && \
    rm -f /zookeeper-${ZOOKEEPER_VERSION}.tar.gz

RUN chown -R bitnami:bitnami /opt/bitnami/zookeeper/ /var/zookeeper 

COPY rootfs /

USER bitnami

EXPOSE 2181 3888 2888

CMD ["zkServer.sh", "start-foreground"]


