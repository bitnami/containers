FROM scratch
COPY prebuildfs /

COPY rootfs /

USER 1001
ENTRYPOINT [ "/default-user-credential-updater" ]
