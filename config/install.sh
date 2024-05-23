#!/bin/bash

DELAY=0.1

# Wait for a file or a directory
wait_for() {
	echo "Waiting for \"$1\"..."
	until [[ -e "$1" || -d "$1" ]]; do
		sleep $DELAY
	done
}

for HAND in right left; do
	[[ $HAND == "right" ]] && short="RH" || short="LH"

	LABEL="GLV80${short}BOOT"
	DEVICE="/dev/disk/by-label/$LABEL"
	MOUNTPOINT="$HOME/media/$LABEL/"
	FILE="$HAND.uf2"

	wait_for "$DEVICE"

	udiskie-mount "$DEVICE" 

	wait_for "$MOUNTPOINT"

	cp -v "$FILE" "$MOUNTPOINT"
done

echo "Done."
