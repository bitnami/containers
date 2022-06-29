FROM scratch
COPY prebuildfs /

COPY rootfs /
ENV PATH="/"

USER 1001
ENTRYPOINT [ "/pinniped-concierge" ]
