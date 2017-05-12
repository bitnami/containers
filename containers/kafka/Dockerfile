FROM bitnami/minideb-extras:jessie-r15

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=kafka \
    BITNAMI_IMAGE_VERSION=0.1-r0 \
    KAFKA_VERSION=0.10.2.1 \ 
    KAFKA_SCALA_VERSION=2.12  \ 
    PATH=/opt/bitnami/kafka/bin:/opt/bitnami/java/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27

# Install kafka
RUN curl -O  http://apache.mirrors.lucidnetworks.net/kafka/${KAFKA_VERSION}/kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}.tgz 

RUN mkdir -p /opt/bitnami/kafka && \
    tar -vzxf /kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt/bitnami/kafka --strip-components 1  && \
    rm /kafka_${KAFKA_SCALA_VERSION}-${KAFKA_VERSION}.tgz

RUN chown -R bitnami:bitnami /opt/bitnami/kafka/

COPY rootfs /

USER bitnami 

EXPOSE 9092

CMD ["/start-kafka.sh"]
