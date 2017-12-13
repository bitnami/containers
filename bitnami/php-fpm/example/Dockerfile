FROM bitnami/php-fpm:7.1 as builder
COPY . /app
WORKDIR /app
# Optionally install application dependencies here. For example using composer.

FROM bitnami/php-fpm:7.1-prod
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 9000
CMD ["php-fpm", "-F", "--pid" , "/opt/bitnami/php/tmp/php-fpm.pid", "-c", "/opt/bitnami/php/conf/php-fpm.conf"]
