#!/bin/bash

cd /opt/bitnami/bedrock/web/app/themes
composer create-project roots/sage sage
cd sage
composer install
npm install --global yarn
yarn
yarn build