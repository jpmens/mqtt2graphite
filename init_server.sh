#!/bin/bash

################################################
# Get Variable
################################################

if [ "$2" != "" ]; then
    MQTT_HOST=$1
    CARBON_SERVER=$2
else
    echo "Usage: $0 mqtt.hostname carbon.hostname '[Debug monde (True/False)]"
    exit
fi

if [ "$3" != "" ]; then
    DEBUG=$3
else
    DEBUG=False
fi

PYTHONCMD=$(which python)
MQTT2GRAPHITECMD=$(readlink -f ./mqtt2graphite.py)

################################################
# Check if the supervisor is already initialized
################################################

if [  ! -d /etc/supervisord.d ]; then
    mkdir /etc/supervisord.d
fi

if [  ! -f /etc/supervisord.conf ]; then
	echo_supervisord_conf | grep -v '^;' > /etc/supervisord.conf

	echo "[include]" >> /etc/supervisord.conf
	echo "files = /etc/supervisord.d/*.conf" >> /etc/supervisord.conf
fi

# Configure the mqtt2graphite supervisor stater script
echo "
[program:mqtt2graphite]
command=$PYTHONCMD $MQTT2GRAPHITECMD $MQTT_HOST.conf
environment=MQTT_HOST='$1',CARBON_SERVER='$CARBON_SERVER',DEBUG=$DEBUG
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=/tmp/mqtt2graphite.log
startsecs=5" > /etc/supervisord.d/mqtt2graphite.conf

# Copy the default map to the MQTT_HOST.conf

if [  ! -f $MQTT_HOST.conf ]; then
    cp map $MQTT_HOST.conf
fi

echo "execute or add this cmd 'supervisord -c /etc/supervisord.conf' in your /etc/rc.local"

