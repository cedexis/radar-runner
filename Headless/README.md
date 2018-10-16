# headless-radar

Firefox and Chrome can both be run in headless mode, which is an effective way to run Radar sessions on a server. The example here is for Firefox.

## Install Firefox

On Debian/Ubuntu:

```bash
apt update
apt install firefox
```

It's best to install a recent version of Firefox. Browser bugs are fixed all the time, and headless support wasn't added until Firefox 55.

## Create a shell script to run Radar

The following script demonstrates how to execute a Radar session on a headless server. You would arrange to execute it periodically using any method of your choosing, e.g. cron, systemd timers, etc. You may also want to configure it to run under an unprivileged account.

Example contents:

```bash
#!/bin/bash

firefox -headless "http://radar.cedexis.com/1/10816/radar.html" &

# Sleep long enough for the session to complete
sleep 20

# Ask Firefox to terminate
pkill firefox
```

Radar sessions typically need a few seconds to complete, so the `sleep` command provides enough time for Firefox to load the test page and for the Radar client to run a session before the `pkill` command signals Firefox to terminate.

Radar only measures platforms whose protocol matches that with which the Radar test page was called. In this example, we're hitting the HTTP endpoint, so we'll only measure platforms that have HTTP URLs. If you wish to measure HTTPS platforms, you should make sure to specify HTTPS in the URL for radar.html. If you need to measure both protocols, then you'll need to arrange for Firefox to be invoked for HTTP and HTTPS separately. For example, you could create two scripts like the one shown above, one for HTTP and one for HTTPS. You'll need to arrange for them to be invoked separately with enough time for each to complete comfortably. With cron, you might do this by scheduling one script to run every 10 minutes starting at the top of the hour and the other script to run every 10 minutes starting at the 5th minute of the hour.

Example crontab:

```crontab
*/10 * * * * /etc/cron.d/run-radar-for-http.sh >/dev/null 2>&1
5-59/10 * * * * /etc/cron.d/run-radar-for-https.sh >/dev/null 2>&1
```

Aside from the protocol, test page URLs include a Cedexis customer id (`10816` in the example script above).  In your own script implementation, you should replace this with your Cedexis customer id, which you can find in the Cedexis Portal on the Radar tag page: https://portal.cedexis.com/ui/radar/tag.

<img src="../portal-cid.png" alt="Customer ID from Radar Tag Page" width="320px">

### Choosing platforms

A common use case for running Radar from headless servers is to ensue a steady flow of Radar data for private platforms.  In order to ensure that the client always measures specific platforms, you can include a *providers-set* parameter in the test page URL with its value set to a comma-separated list of platform ids. 

For example, to instruct the client to always measure platform id 123 and 456, the test page URL would be:

<pre>http://radar.cedexis.com/1/&lt;customer id&gt;/radar.html?providers-set=123,456</pre>

The platform ids for your private providers can be found in the Portal on the Platforms page: https://portal.cedexis.com/ui/platforms.
 
## Known Issues

### Glib messages

You may notice many messages emitted to the console like this:

    (firefox:28693): GLib-GObject-CRITICAL **: g_object_unref: assertion 'object->ref_count > 0' failed
    
These may be safely ignored.

You may also see errors like these:

```bash
ExceptionHandler::GenerateDump cloned child 116335
ExceptionHandler::SendContinueSignalToChild sent continue signal to child
ExceptionHandler::WaitForContinueSignal waiting for continue signal...
Segmentation fault
Failed to connect to Mir: Failed to connect to server socket: No such file or directory
Unable to init server: Could not connect: Connection refused
```

This usually means a newer version of Firefox is being used without passing it the `-headless` parameter.
