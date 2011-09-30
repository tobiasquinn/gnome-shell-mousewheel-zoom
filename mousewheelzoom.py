#!/usr/bin/env python

# gnome-shell-mousewheel-zoom

# (c) Sep 2011, Tobias Quinn <tobias@tobiasquinn.com>
# GPLv3

import dbus
from dbus import DBusException
session_bus = dbus.SessionBus()

from Xlib.display import Display
from Xlib import X
from Xlib.error import ConnectionClosedError

buttons = [X.Button4, X.Button5]
masks = [0, X.LockMask, X.Mod2Mask, X.LockMask | X.Mod2Mask]
incr = 0.1

class Zoomer:
    def __init__(self):
        self._refreshDBUS()
        self._active = self._mag.isActive()
        cz = self._zoom.getMagFactor()
        self._currentZoom = [cz[0], cz[1]]

    def _refreshDBUS(self):
        self._mag = session_bus.get_object(
                'org.gnome.Magnifier',
                '/org/gnome/Magnifier')
        self._mag.getZoomRegions()
        self._zoom = session_bus.get_object(
                'org.gnome.Magnifier',
                '/org/gnome/Magnifier/ZoomRegion/zoomer0')

    def zoomIn(self):
        if self._active:
            self._currentZoom[0] += incr
            self._currentZoom[1] += incr
            try:
                self._zoom.setMagFactor(self._currentZoom[0], self._currentZoom[1])
            except DBusException:
                self._refreshDBUS()
        else:
            try:
                self._zoom.setMagFactor(1 + incr, 1 + incr)
            except DBusException:
                self._refreshDBUS()
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
                try:
                    self._zoom.setMagFactor(self._currentZoom[0], self._currentZoom[1])
                except DBusException:
                    self._refreshDBUS()

def main():
    z = Zoomer()
    # setup xlib
    disp = Display()
    root = disp.screen().root
    # grab a buttons with a modifier
    for mask in masks:
        for button in buttons:
            root.grab_button(button,
                    X.Mod1Mask | mask,
                    root,
                    False,
                    X.GrabModeAsync,
                    X.GrabModeAsync,
                    X.NONE,
                    X.NONE)

    while 1:
        try:
            event = root.display.next_event()
        except ConnectionClosedError:
            pass
        try:
            if event.detail == X.Button4:
                z.zoomIn()
            elif event.detail == X.Button5:
                z.zoomOut()
        except AttributeError:
            pass

if __name__ == '__main__':
    main()
