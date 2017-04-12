#!/bin/bash -x

# apt sources
# uncomment the "deb" lines (no need to uncomment "deb src" lines)

# Edit the “/etc/apt/sources.list” file to configure the package manager. This
# file contains a list of mirrors that the package manager queries. By default,
# this file has all fields commented out, so the package manager will not have
# access to any mirrors. The following command uncomments all commented out
# lines starting with "deb". These contain the mirrors we are interested in.
sudo perl -pi -e 's/^#+\s+(deb\s+http)/$1/g' "/etc/apt/sources.list"

# When writing our linux applications, we want to use ARM DS-5’s remote
# debugging feature to automatically transfer our binaries to the target device
# and to start a debugging session. The remote debugging feature requires an SSH
# server and a remote gdb server to be available on the target. These are easy
# to install as we have a package manager available
sudo apt update
sudo apt -y install ssh gdbserver nano ntp

# Allow compiling binaries directly on the target board by installing the
# standard compilation toolchain. Since the library for exploiting the Pyramic
# ships with the base system image, a developer does not need Altera's libaries
# to compile, thus this can be done directly on the board.
sudo apt -y install gcc make binutils

# Allow root SSH login with password (needed so we can use ARM DS-5 for remote
# debugging)
sudo perl -pi -e 's/^(PermitRootLogin) without-password$/$1 yes/g' "/etc/ssh/sshd_config"

# Test the Pyramic array
pushd /opt/pyramic/application/libpyramicio_test
make
sudo ./libpyramicio_test
popd

echo "Pyramic test completed. You should hear the ambient noise around you \
through the board's sound output (green port of the DE1-SoC). \
\
If you don't, please check the Pyramic is connected to the GPIO 0 port, and \
that all the cables are connected to microphone boards."
