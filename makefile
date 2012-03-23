mousewheelzoom: mousewheelzoom.vala
	valac mousewheelzoom.vala --pkg gio-2.0 --pkg x11

debug: mousewheelzoom.vala
	valac -g --save-temps mousewheelzoom.vala --pkg gio-2.0 --pkg x11

clean:
	rm -f mousewheelzoom mousewheelzoom.c
