FROM gcr.io/stacksmith-images/ubuntu:14.04-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=jenkins \
    BITNAMI_IMAGE_VERSION=2.22-r0 \
    PATH=/opt/bitnami/tomcat/bin:/opt/bitnami/git/bin:/opt/bitnami/java/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_101-0 --checksum 66b64f987634e1348141e0feac5581b14e63064ed7abbaf7ba5646e1908219f9
RUN bitnami-pkg install tomcat-8.5.5-0 --checksum ba4f84698bca14250149482339d26618c92de0662da9d1b39ee34ceaf71cf670
RUN bitnami-pkg install git-2.6.1-1 --checksum e50e7a845e583c4f275ebd9899f378dc6a7e96e830324ae378540aa7940acbb7

# Install jenkins
RUN bitnami-pkg unpack jenkins-2.22-0 --checksum 32c9e2d66a740a79b5c4b0f66002c37a340a0f98fea16b4081049d384dc4e2c4

COPY rootfs /

VOLUME ["/bitnami/jenkins"]

EXPOSE 8080 8443 50000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "tomcat"]
