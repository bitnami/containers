FROM scratch
COPY prebuildfs /

COPY rootfs /

USER 1001
ENTRYPOINT [ "/kube-rbac-proxy" ]
