#!/usr/bin/env python

# gnome-shell-mousewheel-zoom

# (c) Sep 2011, Tobias Quinn <tobias@tobiasquinn.com>
# GPLv3

import dbus
session_bus = dbus.SessionBus()

from Xlib.display import Display
from Xlib import X

buttons = [X.Button4, X.Button5]
incr = 0.1

class Zoomer:
    def __init__(self):
        self._mag = session_bus.get_object(
                'org.gnome.Magnifier',
                '/org/gnome/Magnifier')
        self._mag.getZoomRegions()
        self._zoom = session_bus.get_object(
                'org.gnome.Magnifier',
                '/org/gnome/Magnifier/ZoomRegion/zoomer0')
        self._active = self._mag.isActive()
        cz = self._zoom.getMagFactor()
        self._currentZoom = [cz[0], cz[1]]

    def zoomIn(self):
        if self._active:
            self._currentZoom[0] += incr
            self._currentZoom[1] += incr
            self._zoom.setMagFactor(self._currentZoom[0], self._currentZoom[1])
        else:
            self._zoom.setMagFactor(1 + incr, 1 + incr)
            self._currentZoom = [1 + incr, 1 + incr]
            self._mag.setActive(True)
            self._active = True

    def zoomOut(self):
        if self._active:
            self._currentZoom[0] -= incr
            self._currentZoom[1] -= incr
            if self._currentZoom[0] <= 1:
                self._mag.setActive(False)
                self._active = False
            else:
                self._zoom.setMagFactor(self._currentZoom[0], self._currentZoom[1])

def main():
    z = Zoomer()
    # setup xlib
    disp = Display()
    root = disp.screen().root
    # grab a buttons with a modifier
    for button in buttons:
        root.grab_button(button,
                X.Mod1Mask,
                root,
                False,
                X.GrabModeAsync,
                X.GrabModeAsync,
                X.NONE,
                X.NONE)

    while 1:
        event = root.display.next_event()
        try:
            if event.detail == X.Button4:
                z.zoomIn()
            elif event.detail == X.Button5:
                z.zoomOut()
        except AttributeError:
            pass

if __name__ == '__main__':
    main()
