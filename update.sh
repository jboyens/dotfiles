#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix-update

# shellcheck shell=bash

nix-update -F \
	-vr 'pizauth-(.*)' \
	--build pizauth

nix-update -F \
	--build i3keys

nix-update -F \
	--build pragmasevka

nix-update -F \
	--build cyrus-sasl-xoauth2

./update-moment.sh
