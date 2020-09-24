FROM scratch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /

COPY rootfs /

EXPOSE 8080

USER 1001
CMD [ "/assetsvc" ]
