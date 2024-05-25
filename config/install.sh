#!/bin/bash

DELAY=0.1

# Wait for a condition
wait_for() {
	if [[ "$#" -eq 2 ]]; then
		echo "Waiting for \"$2\" to appear..."
		until test $1 "$2"; do sleep $DELAY; done
	else
		echo "Waiting for \"$3\" to disappear..."
		until test $1 $2 "$3"; do sleep $DELAY; done
	fi
}

install() {
	HAND=$1

	[[ $HAND == "right" ]] && SHORT="RH" || SHORT="LH"

	LABEL="GLV80${SHORT}BOOT"
	DEVICE="/dev/disk/by-label/$LABEL"
	MOUNTPOINT="$HOME/media/$LABEL/"
	FILE="$HAND.uf2"

	wait_for -e "$DEVICE"

	udiskie-mount "$DEVICE" 

	wait_for -d "$MOUNTPOINT"

	cp -v "$FILE" "$MOUNTPOINT"

	wait_for ! -e "$DEVICE"

	echo "Finished with $HAND."
}

for HAND in right left; do
	install $HAND &
done

wait

echo "Done."
