#!/usr/bin/env python
from gi.repository import Gio
import time, subprocess

# interval for unclutter -idle
INTERVAL = 1

MAG_INTERFACE = 'org.gnome.Magnifier'
MAG_PATH = '/org/gnome/Magnifier'

bus = Gio.bus_get_sync(Gio.BusType.SESSION, None)
mag = Gio.DBusProxy.new_sync(bus, Gio.DBusProxyFlags.NONE, None,
        MAG_INTERFACE, MAG_PATH, MAG_INTERFACE, None)

unclutter = None
lastActive = False
while True:
    time.sleep(INTERVAL)
    active = mag.isActive()
    if lastActive != active:
        lastActive = active
        if active:
            # hide cursor
            if unclutter == None:
                unclutter = subprocess.Popen(['unclutter', '-idle', '%d' % (INTERVAL)])
        else:
            # show cursor
            if unclutter != None:
                unclutter.kill()
                unclutter = None
