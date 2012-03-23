// gnome-shell-mousewheel-zoom

// (c) Mar 2012, Tobias Quinn <tobias@tobiasquinn.com>
// GPLv3

using X;
using GLib;

const int MOUSEWHEEL_UP   = 4;
const int MOUSEWHEEL_DOWN = 5;

const int[] BUTTONS = { MOUSEWHEEL_UP, MOUSEWHEEL_DOWN };

[DBus (name = "org.gnome.Magnifier")]
interface Magnifier : Object {
    public abstract bool isActive() throws IOError;
    public abstract void setActive(bool active) throws IOError;
    public abstract GLib.ObjectPath[] getZoomRegions() throws IOError;
}

[DBus (name = "org.gnome.Magnifier.ZoomRegion")]
interface ZoomRegion : Object {
    public abstract void setMagFactor(double xMagFactor, double yMagFactor) throws IOError;
    public abstract double getMagFactor() throws IOError;
}

class Zoomer : GLib.Object {
    // DBus proxy objects
    private Magnifier mag;
    private ZoomRegion zoom;

    // Zoom state
    private const double incr = 0.1;
    private double current_zoom;
    private bool zoom_active;
    private bool interfaces_active;

    public Zoomer() {
        interfaces_active = false;
        while (!interfaces_active) {
            refresh_dbus();
        }
        // get current zoom state
        zoom_active = mag.isActive();
        current_zoom = zoom.getMagFactor();
    }

    private void refresh_dbus() {
        try {
            mag = Bus.get_proxy_sync(BusType.SESSION,
                    "org.gnome.Magnifier",
                    "/org/gnome/Magnifier");
            // refresh zoom regions (exposes ZoomRegion interface)
            mag.getZoomRegions();
            zoom = Bus.get_proxy_sync(BusType.SESSION,
                    "org.gnome.Magnifier",
                    "/org/gnome/Magnifier/ZoomRegion/zoomer0");
        } catch (IOError e) {
        }
        interfaces_active = true;
    }

    public void zoomIn() {
        if (zoom_active) {
            current_zoom *= (1 + incr);
        } else {
            current_zoom *= (1 + incr);
            mag.setActive(true);
            zoom_active = true;
        }
        try {
            zoom.setMagFactor(current_zoom, current_zoom);
        } catch (IOError e) {
            refresh_dbus();
        }
    }

    public void zoomOut() {
        if (zoom_active) {
            current_zoom *= (1.0 - incr);
            if (current_zoom <= 1) {
                current_zoom = 1;
                mag.setActive(false);
                zoom_active = false;
            } else {
                try {
                    zoom.setMagFactor(current_zoom, current_zoom);
                } catch (IOError e) {
                    refresh_dbus();
                }
            }
        }
    }
}

class WaitForMagnifier : GLib.Object {
    private MainLoop loop;
    private bool running = false;
    private int count = 0;

    private bool doStuff() {
        if (!running) {
            message("NOT Doing stuff %d", count++);
        } else {
        }
        return true;
    }

    public WaitForMagnifier() {
        DBusConnection conn = Bus.get_sync(BusType.SESSION);
        //Bus.watch_name(BusType.SESSION,
        Bus.watch_name_on_connection(conn,
            "org.gnome.Magnifier",
            BusNameWatcherFlags.NONE,
            on_name_appeared,
            on_name_vanished);
        this.loop = new MainLoop();
        Idle.add(doStuff);
        this.loop.run();
    }

    private void on_name_appeared() {
        message("name appeared\n");
        running = true;
//        this.loop.quit();
    }

    private void on_name_vanished() {
        message("name vanished\n");
        running = false;
    }
}

void main(string[] arg) {
    // wait for the magnifier service to become available
//    WaitForMagnifier waiter = new WaitForMagnifier();
            X.Display disp = new X.Display();
            X.Window root = disp.default_root_window();
            foreach (int button in BUTTONS) {
                disp.grab_button(button,
                        X.KeyMask.Mod2Mask | X.KeyMask.Mod1Mask,
                        root,
                        false,
                        0,
                        X.GrabMode.Async,
                        X.GrabMode.Async,
                        0,
                        0);
            }

            X.Event evt = Event();
            Zoomer zoom = new Zoomer();
            while (true) {
                disp.next_event(ref evt);
                switch(evt.xbutton.button) {
                    case MOUSEWHEEL_UP:
                        zoom.zoomIn();
                        break;

                    case MOUSEWHEEL_DOWN:
                        zoom.zoomOut();
                        break;

                    default:
                        stdout.printf("mousewheelzoom (vala) uncaught event\n");
                        break;
                }
            }

}
