# gnome-shell-mousewheel-zoom

(c) Sep 2011, Tobias Quinn <tobias@tobiasquinn.com>

GPLv3

This uses python-xlib and python-dbus to allow the gnome shell to be zoomed
like enhanced zoom desktop in compiz using the modification key and mouse scrollwheel

## COnfiguration
To select the modifier key use dconf-editor and navigate to:
com -> tobiasquinn.com -> mousewheelzoom -> modifier-key
Note: mousewheelzoom needs to be restarted to reload the configuration

Note: config only works with the precise and quantal builds (master branch)

## Branches
The branches have recently changed master is for gnome 3.4 onwards (ubuntu precies and quantal).

oneiric branch is for ubuntu oneiric and uses python-xlib

There is also a ubuntu precise port using gsettings in the branch precise-gsettings.

## Arch Linux
There is an archlinux PKGBUILD provided (available from AUR as gnome-shell-mousewheel-zoom-git)

## Ubuntu
A ppa for Ubuntu oneiric, precise and quantal is available from:

https://launchpad.net/~tobias-quinn/+archive/gsmz

to install do:

sudo add-apt-repository ppa:tobias-quinn/gsmz
sudo apt-get update
sudo apt-get install gnome-shell-mousewheel-zoom

## hideonzoom.py
There's also hideonzoom.py which hides the cursor during inactivity. It needs unclutter package.

