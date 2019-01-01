#!/usr/bin/env bash

if command -v aseprite >/dev/null; then
  echo "Aseprite is already installed"
  exit 1
fi

# Install dark theme from: https://github.com/tungkradle/aseprite-than/releases
yay -S --needed aseprite

# set -e
# yay --needed --noconfirm -S ninja cmake libxcursor
# rm -rf /tmp/aseprite
# if git clone --recursive https://github.com/aseprite/aseprite /tmp/aseprite; then
#   mkdir /tmp/aseprite/build && cd /tmp/aseprite/build
#   cmake -DCMAKE_INSTALL_PREFIX=/usr -G Ninja ..
#   ninja aseprite
#   ninja install
# fi
