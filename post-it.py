#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Un app-indicator très simple qui ouvre des post-it placés dans un dossier
# créé par Pseudomino à partir de indicator-places le 18/12/2011
#

import os
import gtk
import gio
import signal
import subprocess
import appindicator
import urllib

APP_NAME = 'indicator-post-it'
APP_VERSION = '0.1'

class IndicatorPostit:

    def __init__(self):
        self.ind = appindicator.Indicator("post-it", "tomboy",
appindicator.CATEGORY_APPLICATION_STATUS)
        self.ind.set_status(appindicator.STATUS_ACTIVE)

        self.update_menu()

    def create_menu_item(self, label, icon_name):
        image = gtk.Image()
        image.set_from_icon_name(icon_name, 24)

        item = gtk.ImageMenuItem()
        item.set_label(label)
        item.set_image(image)
        item.set_always_show_image(True)
        return item


    # Méthode pour créer un menu
    def update_menu(self, widget = None, data = None):

        # Créer le menu
        menu = gtk.Menu()
        self.ind.set_menu(menu)

        # Lister les post-it
        listing = os.listdir('/home/fpaut/Perso/NO_BACKUP/Doc_Perso/TODO/');
        for path in listing:
                item = self.create_menu_item(path, "tomboy")
                item.connect("activate", self.on_postit_click, path)
                menu.append(item)
    
                # Afficher le menu
                menu.show_all()


    # Ouvrir un post-it
    def on_postit_click(self, widget, path):
        subprocess.Popen('xdg-open /home/fpaut/Perso/NO_BACKUP/Doc_Perso/TODO/' + path, shell = True)


if __name__ == "__main__":
    # Catch CTRL-C
    signal.signal(signal.SIGINT, lambda signal, frame: gtk.main_quit())

    # Lancer l'indicator
    i = IndicatorPostit()

    # Boucle gtk principale
    gtk.main()
