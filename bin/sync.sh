#!/bin/bash

echo "Starting setup..."

openvas-mkcert -f -q
ldconfig
openvassd
openvas-nvt-sync
openvas-scapdata-sync
openvas-certdata-sync
openvas-mkcert-client -n -i
