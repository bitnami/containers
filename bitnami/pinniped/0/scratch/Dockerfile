FROM scratch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY prebuildfs /

COPY rootfs /
ENV PATH="/"

USER 1001
ENTRYPOINT [ "/pinniped-concierge" ]
