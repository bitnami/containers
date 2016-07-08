FROM gcr.io/stacksmith-images/ubuntu:14.04-r07

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=odoo \
    BITNAMI_IMAGE_VERSION=9.0.20160620-r0 \
    PATH=/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/postgresql/bin:$PATH

# Additional modules required
RUN bitnami-pkg install python-2.7.12-0 --checksum 1a55e9c5af791fd9a5744919d71e1442a11c413bab5cff0be44c8dbeb0145959
RUN bitnami-pkg install postgresql-client-9.5.3-0 --checksum f37cd1644594f5acf08dff89dbdbf156982ffbf14d73786c2e47154c77ac658a
RUN bitnami-pkg install postgresql-libraries-9.5.3-0 --checksum d6499811161e9e97acfc3e0132a016bc2edcfd85374c9b5002359429bd8ab698
RUN bitnami-pkg install node-6.3.0-0 --checksum f2997c421e45beb752673a531bf475231d183c30f7f8d5ec1a5fb68d39744d5f

# Install odoo
RUN bitnami-pkg unpack odoo-9.0.20160620-0 --checksum 4c71a5261d916880f89139bb4f469966a69c7505786bf8eb3eca770f200865fc

COPY rootfs /

VOLUME ["/bitnami/odoo"]

EXPOSE 8069 8071

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["harpoon", "start", "--foreground", "odoo"]
