FROM scratch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /

COPY rootfs /

EXPOSE 3000

USER 1001
CMD [ "/keycloak-gatekeeper" ]
