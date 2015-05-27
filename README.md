# Bash scripts
A collection of (useful) bash scripts for Linux.

## How to use

 1. Download the script you want.
 2. Run ``chmod +x script.sh`` to make it executable
 3. Run it with ``./script.sh``

## buildpdf.sh

A script for automatically creating PDf files from a latex document. You can set the amounts of builds and the time between the builds.

**Usage:** ``./buildpdf.sh filename [build amount] [time between builds in s]``

## intellij-hidpi.sh

This is a small script for enabling and disabling HiDPI support on IntelliJ IDEA Community Edition on every Linux distribution where IntelliJ is installed in /usr/share/intellijidea-ce/. If the installation is somewhere else you have to change the variable IDEA_PATH.

**Usage:**

 - Help: ``./intellij-hidpi.sh -h``
 - Enable ``./intellij-hidpi.sh -e``
 - Disable ``./intellij-hidpi.sh -d``

## android-studio-hidpi.sh

This is a small script for enabling and disabling HiDPI support in Android Stuido on every linux distribution where Android Stuido is installed in /opt/android-studio. If the installation is somewhere else you have to change the variable STUDIO_PATH.

**Usage:**

 - Help: ``./android-studio-hidpi.sh -h``
 - Enable ``./android-studio-hidpi.sh -e``
 - Disable ``./android-studio-hidpi.sh -d``

## License

Each script is licensed under GNU GPL v3.0.
