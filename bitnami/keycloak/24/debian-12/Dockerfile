FROM redhat/ubi9:9.4

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
ARG TARGETARCH
ENV LANG en_US.UTF-8
ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-12" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "errexit", "-o", "nounset", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN dnf install -y tar gzip hostname wget sudo
RUN chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo
RUN sudo fips-mode-setup --enable
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "wait-for-port-1.0.7-13-linux-${OS_ARCH}-debian-12" \
      "java-17.0.11-12-0-linux-${OS_ARCH}-debian-12" \
      "keycloak-24.0.5-0-linux-${OS_ARCH}-debian-12" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN chmod g+rwX /opt/bitnami
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/keycloak/postunpack.sh
ENV APP_VERSION="24.0.5" \
    BITNAMI_APP_NAME="keycloak" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/keycloak/bin:$PATH"
RUN mkdir -p /quarkus && cp -r /opt/bitnami/keycloak/lib/quarkus/* /quarkus

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/keycloak/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/keycloak/run.sh" ]


# docker build --no-cache --progress=plain -t us-docker.pkg.dev/vorvan/dev/bitnami-keycloak-ubi9:latest .