#!/bin/bash
export COMPOSER_ALLOW_SUPERUSER=1
cd /opt/bitnami/
composer create-project roots/bedrock bedrock
cd ./bedrock
composer install
cp -R /opt/bitnami/wordpress/wp-content/plugins/* /opt/bitnami/bedrock/web/app/plugins/
cp -R /opt/bitnami/wordpress/wp-content/themes/* /opt/bitnami/bedrock/web/app/themes/