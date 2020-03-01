#!/bin/bash

set -euo pipefail
IFS=$'\t\n'

for i in styles/*.scss
do
  sass --sourcemap=none --no-cache --style compressed --default-encoding utf-8 styles/youtube.scss >> ~/.local/share/qutebrowser/userstyles.css
done
