#!/bin/bash

find "/opt/bitnami/apache/conf/vhosts" -type f -name "*.conf" -exec sed -i 's|/opt/bitnami/wordpress|/opt/bitnami/bedrock/web|g' {} +
