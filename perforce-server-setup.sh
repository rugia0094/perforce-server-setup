#!/bin/bash

# FILL THIS FIRST!

SERVICE_NAME='AntonPerforceService'
P4PORT=1666
P4ROOT='/opt/perforce/servers/AntonPerforceService'
SUPERUSER_LOGIN_NAME='login' # p4dctl must be executed by system user with same name
SUPERUSER_PASSWORD='password' # must be strong

# Delete line below after filling vars above.
exit 0

echo '[perforce-server-setup.sh]: Start'
echo '[perforce-server-setup.sh]: Check if sudo'

if [ "$(id -u)" -ne 0 ]; then
  echo "Repeat with sudo" >&2
  exit 1
fi

echo '[perforce-server-setup.sh]: Pre apt update'

apt update
apt-get update

echo '[perforce-server-setup.sh]: Install wget and gnupg2'

apt install -y wget gnupg2

echo '[perforce-server-setup.sh]: Add Perforce packaging key to APT keyring'

DISTRO=$(lsb_release -sc) # noble
OS="ubuntu"

wget -qO - https://package.perforce.com/perforce.pubkey | gpg --dearmor | sudo tee /usr/share/keyrings/perforce.gpg
echo "deb [signed-by=/usr/share/keyrings/perforce.gpg] https://package.perforce.com/apt/$OS $DISTRO release" > /etc/apt/sources.list.d/perforce.list
apt update
apt-get update

echo '[perforce-server-setup.sh]: Install p4-server'

apt-get install -y p4-server

echo '[perforce-server-setup.sh]: Run configure-p4d.sh'

/opt/perforce/sbin/configure-p4d.sh $SERVICE_NAME -n -p $P4PORT -r $P4ROOT -u $SUPERUSER_LOGIN_NAME -P "$SUPERUSER_PASSWORD" --unicode --case 0
