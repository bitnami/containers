FROM gcr.io/stacksmith-images/minideb:jessie-r10

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=jenkins \
    BITNAMI_IMAGE_VERSION=2.47-r2 \
    PATH=/opt/bitnami/tomcat/bin:/opt/bitnami/git/bin:/opt/bitnami/java/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27
RUN bitnami-pkg install tomcat-8.0.41-1 --checksum 3bbbdae242e8dc35ac2f7725fee1169950c4cc55a7c488a49fb21ba060dbeb88
RUN bitnami-pkg install git-2.10.1-2 --checksum 6f9fd8b0591f268f965930db0c091598e5c4f9dccbb6853010e1ac9e5035cd6f

# Install jenkins
RUN bitnami-pkg unpack jenkins-2.47-1 --checksum 1c88a09c3c128e51006c1dd9466e6f418b7a947afd424d99d59fe84ccbcf2a2c

COPY rootfs /

ENV JENKINS_USERNAME="user" \
    JENKINS_PASSWORD="bitnami"

VOLUME ["/bitnami/jenkins"]

EXPOSE 8080 8443 50000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "tomcat"]
