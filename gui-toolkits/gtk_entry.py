#!/usr/bin/python

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk


class PyApp(Gtk.Window):

    def __init__(self):
        super(PyApp, self).__init__()

        self.set_title("Entry")
        self.set_size_request(250, 200)

        fixed = Gtk.Fixed()

        self.label1 = Gtk.Label("label 1")
        fixed.put(self.label1, 400, 40)

        self.label2 = Gtk.Label("label 2")
        fixed.put(self.label2, 400, 80)

        entry = Gtk.Entry()
        entry2 = Gtk.Entry()
        fixed.put(entry, 50, 40)
        fixed.put(entry2, 50, 80)

        # really every key release
        # entry.connect("key-release-event", self.on_key_release)

        # tabing away
        entry.connect("focus-out-event", self.on_key_release)
        # enter press
        entry.connect("activate", self.on_key_release)

        entry2.connect("focus-out-event", self.on_key_release2)
        entry2.connect("activate", self.on_key_release2)

        self.connect("destroy", Gtk.main_quit)
        self.add(fixed)
        self.show_all()

    # DRY ??

    def on_key_release(self, widget, event=None):
        print("key release:", event)
        self.label1.set_text(widget.get_text())

    def on_key_release2(self, widget, event=None):
        print("key release:", event)
        self.label2.set_text(widget.get_text())

PyApp()
Gtk.main()

