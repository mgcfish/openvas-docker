#!/bin/bash

echo "Starting Redis"
/usr/local/bin/redis-server /etc/redis/redis.config

echo "Starting Openvas..."

cd /usr/local/sbin

echo "Starting gsad"
# http://wiki.openvas.org/index.php/Edit_the_SSL_ciphers_used_by_GSAD
./gsad --gnutls-priorities="SECURE128:-AES-128-CBC:-CAMELLIA-128-CBC:-VERS-SSL3.0:-VERS-TLS1.0"
echo "Starting Openvassd"
./openvassd

echo "Starting Openvasmd"
./openvasmd

echo "Checking setup"

until [ $n -eq 50 ]
do
    timeout 10s /openvas/openvas-check-setup --v8 --server;
    if [ $? -eq 0 ]; then
        break;
    fi
    echo "Re-running openvas-check-setup, attempt: $n"
    n=$[$n+1]
    sleep 10 || exit 1
done

echo "Done."

echo 'Delete unknown users...'
openvasmd --get-users | fgrep -v "${OPENVAS_ADMIN_USER}" | xargs -n1 -IUSER -r openvasmd --delete-user=USER
if [[ -z "$(openvasmd --get-users | fgrep "${OPENVAS_ADMIN_USER}")" ]]; then
    echo 'Create admin  user...'
    openvasmd --create-user="${OPENVAS_ADMIN_USER}" --role=Admin
fi
echo 'Set admin password...'
openvasmd --user="${OPENVAS_ADMIN_USER}" --new-password="${OPENVAS_ADMIN_PASSWORD}"

echo "Starting infinite loop..."

echo "Press [CTRL+C] to stop.."

tail -f /usr/local/var/log/openvas/*
