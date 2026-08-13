#!/bin/bash
# Amazon Linux 2023 AMI
dnf -q -y install httpd mod_ssl
echo "My ALB WEB" > /var/www/html/index.html
systemctl enable --now httpd
