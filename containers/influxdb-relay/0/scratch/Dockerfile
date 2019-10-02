FROM scratch
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY rootfs /

EXPOSE 9096 9097

USER 1001
CMD [ "/influxdb_relay" ]
