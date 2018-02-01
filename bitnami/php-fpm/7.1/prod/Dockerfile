
FROM bitnami/php-fpm:7.1 as development

FROM bitnami/minideb-runtimes:jessie-php
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY --from=development /opt/bitnami/common /opt/bitnami/common
COPY --from=development /opt/bitnami/php /opt/bitnami/php

ENV BITNAMI_APP_NAME="php-fpm" \
    BITNAMI_IMAGE_VERSION="7.1.14-r0" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:$PATH"

CMD ["php-fpm","-F","--pid","/opt/bitnami/php/tmp/php-fpm.pid","-c","/opt/bitnami/php/conf/php-fpm.conf"]
