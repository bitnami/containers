FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=odoo \
    BITNAMI_IMAGE_VERSION=9.0.20160620-r4 \
    PATH=/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/postgresql/bin:$PATH

# Additional modules required
RUN bitnami-pkg install python-2.7.12-1 --checksum 1ab49b32453c509cf6ff3abb9dbe8a411053e3b811753a10c7a77b4bc19606df
RUN bitnami-pkg install postgresql-client-9.5.3-4 --checksum 1f6f436e65b6e8405011e86f63775f7db1b5c1c51a3afa41637ee43c282f4951
RUN bitnami-pkg install postgresql-libraries-9.5.3-1 --checksum 7064c8752797ec2d92f2a0ef57d5bbe5a1607e1938a352d9ecf4f455384d90b7
RUN bitnami-pkg install node-6.6.0-1 --checksum 36f42bb71b35f95db3bb21d088fbd9438132fb2a7fb4d73b5951732db9a6771e

# Install odoo
RUN bitnami-pkg unpack odoo-9.0.20160620-0 --checksum 4c71a5261d916880f89139bb4f469966a69c7505786bf8eb3eca770f200865fc

COPY rootfs /

VOLUME ["/bitnami/odoo"]

EXPOSE 8069 8071

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "odoo"]
