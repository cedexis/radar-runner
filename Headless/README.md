# headless-radar

On headless Linux servers, it is possible to run the Radar JavaScript client using
[Xvfb](https://en.wikipedia.org/wiki/Xvfb) and your choice of web browser that
supports the Resource Timing API.  The example provided here assumes the use of
Firefox.

## Install Xvfb and Firefox

On Debian/Ubuntu:

```bash
apt-get update
apt-get install xvfb firefox
```

## Create a shell script to run Radar

This script will do the work of executing Radar sessions.

Example contents:

```bash
#!/bin/sh

xvfb-run -a firefox http://radar.cedexis.com/1/10816/radar.html &
xvfb-run -a firefox https://radar.cedexis.com/1/10816/radar.html &

# Give the Radar session(s) time to complete
sleep 20

# Kill all existing firefox processes
pkill firefox
```

As you can see from the example, the script runs two instances of Firefox,
passing each one a different test page URL.  By default, Radar only measures
platforms whose protocol matches that with which the Radar test page was called,
so in this example, we're hitting both HTTP and HTTPS test pages to ensure both
types of measurements.  If you're only interested in measurements for a certain
protocol, then you may prefer to comment out one of these commands.

Aside from the protocol, test page URLs include a Cedexis customer id.  This is
**10816** in the example script.  In your own script implementation, you should
replace this with your Cedexis customer id, which you can find in the Cedexis
Portal on the Radar tag page: https://portal.cedexis.com/ui/radar/tag.

<img src="../portal-cid.png" alt="Customer ID from Radar Tag Page" width="320px">

Radar sessions typically need a few seconds to complete, so the `sleep` command
gives enough time for Firefox to load the test page and for the Radar client to
run a session before the `pkill` command forces Firefox to close.

You can execute this script periodically with an unprivileged account using any
method of your choosing, e.g. cron, systemd timers, etc.

### Choosing platforms

A common use case for running Radar from headless servers is to ensue a steady
flow of Radar data for private platforms.  In order to ensure that the
client always measures specific platforms, you can include a *providers-set*
parameter in the test page URL with its value set to a comma-separated list of
platform ids. 

For example, to instruct the client to always measure platform id 123, the test
page URL would be:

<pre>http://radar.cedexis.com/1/&lt;customer id&gt;/radar.html?providers-set=123</pre>

The platform ids for your private providers can be found in the Portal on the
Platforms page: https://portal.cedexis.com/ui/platforms.

## A Working Example

For this you'll need [Vagrant](https://www.vagrantup.com/).

Create the virtual machine:

    vagrant up

This creates a virtual machine using your default Vagrant provider, provisioning
it with everything needed to run Radar sessions using Firefox and Xvfb.  It sets
up a cron job to execute the run-radar.sh script once a minute.

When Vagrant is finished setting up the virtual machine, you can log into it
as the vagrant user:

    vagrant ssh

Check to see how the cron job is set up:

    vagrant@vagrant:~$ cat /etc/cron.d/run-radar
    * * * * * vagrant /vagrant/run-radar.sh

When you're finished with the virtual machine, you should shut it down:

    vagrant halt

You can delete it to conserve disk space:

    vagrant destroy -f
    
## Known Issues

### Glib messages

You may notice many messages emitted to the console like this:

    (firefox:28693): GLib-GObject-CRITICAL **: g_object_unref: assertion 'object->ref_count > 0' failed
    
These may be safely ignored.
