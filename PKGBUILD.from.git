# Author: Tobias Quinn <tobias@tobiasquinn.com>
# Maintainer: Tobias Quinn <tobias@tobiasquinn.com>
pkgname=gnome-shell-mousewheel-zoom-git
pkgver=20111021
pkgrel=1
pkgdesc="Enable mousewheel zoom using left-alt key using gnome-shell"
arch=('i686' 'x86_64')
url="https://github.com/tobiasquinn/gnome-shell-mousewheel-zoom"
license=('GPL3')
depends=('python2' 'dbus-python' 'python-xlib' 'gnome-shell')
makedepends=('git')
conflicts=('gnome-shell-mousewheel-zoom-git')
provides=('gnome-shell-mousewheel-zoom-git')

_gitroot="git://github.com/tobiasquinn/gnome-shell-mousewheel-zoom.git"
_gitname="gnome-shell-mousewheel-zoom"

build() {
  cd "$srcdir"
  msg "Connecting to GIT server..."

  if [ -d $_gitname ] ; then
    cd $_gitname && git pull origin
    msg "The local files are updated."
  else
    git clone $_gitroot $_gitname
  fi

  msg "GIT checkout done or server timeout"
  # Change to use python2
  sed -i "s/usr\/bin\/env python$/usr\/bin\/env python2/" ${srcdir}/$_gitname/mousewheelzoom.py

  install -D -m755 ${srcdir}/$_gitname/mousewheelzoom.py "${pkgdir}/usr/bin/mousewheelzoom.py" || return 1
  install -D -m644 ${srcdir}/$_gitname/mousewheelzoom.py.desktop "${pkgdir}/etc/xdg/autostart/mousewheelzoom.py.desktop" || return 1
}

# vim:set ts=2 sw=2 et:
