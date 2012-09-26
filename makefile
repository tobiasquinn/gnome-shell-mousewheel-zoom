# Makefile
# vala project
#
 
# name of your project/program
PROGRAM = mousewheelzoom
 
 
# for most cases the following two are the only you'll need to change
# add your source files here
SRC = mousewheelzoom.vala
 
# add your used packges here
PKGS = --pkg gio-2.0 --pkg x11
 
# vala compiler
VALAC = valac
 
# compiler options for a debug build
VALACOPTS = -g --save-temps
 
# set this as root makefile for Valencia
BUILD_ROOT = 1
 
# the 'all' target build a debug build
all:
	@$(VALAC) $(VALACOPTS) $(SRC) -o $(PROGRAM) $(PKGS)
 
# the 'release' target builds a release build
# you might want to disabled asserts also
release: clean
	@$(VALAC) -X -O2 $(SRC) -o $(PROGRAM) $(PKGS)
 
# clean all built files
clean:
	@rm -v -fr *~ *.c $(PROGRAM)

install: release
	mkdir -p $(DESTDIR)/usr/bin
	install -m 0755 $(PROGRAM) -t $(DESTDIR)/usr/bin
	mkdir -p $(DESTDIR)/etc/xdg/autostart
	install -m 0644 mousewheelzoom.desktop -t $(DESTDIR)/etc/xdg/autostart
	mkdir -p $(DESTDIR)/usr/share/glib-2.0/schemas
	install -m 0644 com.tobiasquinn.mousewheelzoom.gschema.xml -t $(DESTDIR)/usr/share/glib-2.0/schemas
