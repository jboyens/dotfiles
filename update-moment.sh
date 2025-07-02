#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix-update

# shellcheck shell=bash

STAGING=d1zyf2h5975v9k
PROD=d324d25svypnd9
TUPLES="[[\"$PROD\",\"moment\"],[\"$STAGING\",\"moment-staging\"]]"

function profileContains() {
	package=$1

	nix profile list --json | jq -e ".elements|keys|any(. == \"${package}\")"

	return $?
}

echo "$TUPLES" | jq -c '.[]' | while read -r i; do
	hash=$(echo "$i" | jq -r -c '.[0]')
	name=$(echo "$i" | jq -r -c '.[1]')

	if profileContains "$name"; then
		nix-update -F \
			--version "$(curl "https://${hash}.cloudfront.net/tauri/latest-linux-x86_64.json" | jq -r '.version')" \
			--build "$name"

		nix profile upgrade "$name"
	fi
done
