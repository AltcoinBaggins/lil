
Debian
====================
This directory contains files used to package cortezd/cortez-qt
for Debian-based Linux systems. If you compile cortezd/cortez-qt yourself, there are some useful files here.

## pivx: URI support ##


cortez-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install cortez-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your cortez-qt binary to `/usr/bin`
and the `../../share/pixmaps/pivx128.png` to `/usr/share/pixmaps`

cortez-qt.protocol (KDE)

