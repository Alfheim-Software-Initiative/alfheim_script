# Alfheim Linux Build Script
This is the script used to build Alfheim Linux, an Arch based Linux Operating System.

This script is written in Perl and requires Perl 5 in order to run, it also requires File::Slurp which is installed with the script.  At this time it also requires Arch Linux though we are working to make it Linux platform agnostic. In addition to both of these requirements the script uses yaourt instead of pacman, so yaourt is a requirement though you can easily edit the script and replace yaourt with pacman.

It allows you to build two different versions of Alfheim Linux, the preferred (and officially released version) with OpenRC instead of systemd, and a systemd version [COMING SOON].

The easiest way to run it is to clone the git repository and ./alfheim this will give you a menu option to choose to either build the non-systemd or systemd version.
