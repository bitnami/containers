FROM scratch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /

COPY rootfs /

USER 1001
ENTRYPOINT [ "/contour-operator" ]
