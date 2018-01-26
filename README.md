# Alfheim Linux Build Script
This is the script used to build Alfheim Linux, an Arch based Linux Operating System.

This script is written in Perl and requires Perl 5 in order to run, it also requires File::Slurp which is installed with the script.  At this time it also requires Arch Linux though we are working to make it Linux platform agnostic. In addition to both of these requirements the script uses yaourt instead of pacman, so yaourt is a requirement though you can easily edit the script and replace yaourt with pacman.

It allows you to build two different versions of Alfheim Linux, the preferred (and officially released version) with OpenRC instead of systemd, and a systemd version [COMING SOON].

The easiest way to run it is to clone the git repository and ./alfheim this will give you a menu option to choose to either build the non-systemd or systemd version.

To edit the scripts please see docs/editing.

## How to build the iso
1. Clone the git repository
2. cd into the directory that you cloned, if you stayed with the defaults it will be <Directory you were in when you ran the clone>/alfheim_script
3. Run the alfheim command as root (sudo ./alfheim)
4. This command will first install File::Slurp from cpan (Note :: you may be asked to setup CPAN if this your first time using it, it's safe to just use the automatic configuration if you don't want to go through and manually set anything)
5. Next you have a menu option prompting you to either select 1) For the non-systemd build or 2) for the systemd build (non-systemd is the only one that works at this time so press 1)
6. Next it will update the repos and then present you with a list of packages to install from the Arch Linux base package (For the default build we select all but linux-lts, netctl, and systemd-compat)
7. These packages will download and may throw a broken package error if it does select yes to remove for every package that throws this error, exit the program and (sudo rm -rf work) then re-run alfheim as root, this will download a copy of the packages that will not throw that error.
8. Next step will be to install the system packages, select everything from the two openrc groups and from the base-devel group install everything but systemd (should be 1-27)
9. Let the rest of the program do it's job and you should have an Alfheim Linux iso in a while (go get a coffee)
