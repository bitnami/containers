#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

useradd -ms /bin/bash bitnami
mkdir -p /opt/bitnami
sed -i -e 's/\s*Defaults\s*secure_path\s*=/# Defaults secure_path=/' /etc/sudoers
echo 'bitnami ALL=NOPASSWD: ALL' >> /etc/sudoers
