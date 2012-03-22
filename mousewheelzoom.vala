// gnome-shell-mousewheel-zoom

// (c) Mar 2012, Tobias Quinn <tobias@tobiasquinn.com>
// GPLv3

using X;

const int MOUSEWHEEL_UP   = 4;
const int MOUSEWHEEL_DOWN = 5;

const int[] BUTTONS = { MOUSEWHEEL_UP, MOUSEWHEEL_DOWN };

class Zoomer : GLib.Object {
    private const double incr = 0.1;
    private double current_zoom;
    private bool zoom_active;

    public Zoomer() {
    }

    public void zoomIn() {
        stdout.printf("ZI\n");
    }

    public void zoomOut() {
        stdout.printf("ZOUT\n");
    }
}

void main(string[] arg) {
    Display disp = new Display();
    Window root = disp.default_root_window();
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

    Event evt = Event();
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
                stdout.printf("uncaught event\n");
                break;
        }
    }
}
