#!/bin/sh

xvfb-run -a firefox http://radar.cedexis.com/1/10816/radar.html &
xvfb-run -a firefox https://radar.cedexis.com/1/10816/radar.html &

# Give the Radar session(s) time to complete
sleep 20

# Kill all existing firefox processes
pkill firefox
