apt-get -y update
apt-get -y install xvfb firefox

mv /tmp/run-radar /etc/cron.d/
chown root:root /etc/cron.d/run-radar
