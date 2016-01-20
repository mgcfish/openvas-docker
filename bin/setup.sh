#!/bin/bash

echo "Starting openvassd"
openvassd

until ps aux | grep openvassd | grep Waiting | grep -v grep 
do
    ps aux | grep openvassd | grep Reload
    sleep 5
done

echo "Rebuilding Openvasmd..."
timeout 1h openvasmd --rebuild --progress -v || exit # This is critical, build needs to restart

echo "Creating Admin user..."
openvasmd --create-user=${OPENVAS_ADMIN_USER} --role=Admin
echo "Setting Admin user password..."
openvasmd --user=${OPENVAS_ADMIN_USER} --new-password=${OPENVAS_ADMIN_PASSWORD}
echo "Killing some locked up openvassd's"
# At this point, usually openvassd locks up so lets kill it
#ps aux | grep openvassd| awk '{print $2}' |xargs kill -9

echo "Finished setup..."
