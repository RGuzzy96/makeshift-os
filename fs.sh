#!/bin/bash

FOLDER="fs"
VOLUME_LABEL="MAKESHIFTOS"
IMAGE=disk.img

# check if we have mtools installed
if ! command -v "mcopy" >/dev/null 2>&1; then
    echo "Error: this script depends on mtools. Please install it." >&2
    exit 1
fi

# check if we have dosfstools installed
if ! command -v "mkfs.fat" >/dev/null 2>&1; then
    echo "Error: this script depends on dosfstools. Please install it" >&2
    exit 1
fi

SIZE_KB=$(du -s -B1 . | awk '{print int($1/1024)}')
echo $SIZE_KB

get_power_of_two() {
    local n=$1
    local p=1
    while (( p < n)); do
        (( p *= 2))
    done
    echo $p
}

SIZE_MB=$(( (SIZE_KB * 12 / 10 + 1023) / 1024 ))

echo "Size MB before p2: $SIZE_MB"

SIZE_MB=$(get_power_of_two "$SIZE_MB")

echo "Size MB after p2: $SIZE_MB"

# default size if too small
if (( SIZE_MB < 64 )); then
    SIZE_MB=64
fi

dd if=/dev/zero of=$IMAGE bs=1M count=$SIZE_MB

mkfs.fat -F 32 -n "$VOLUME_LABEL" $IMAGE

mcopy -i $IMAGE -s "$FOLDER"/* ::
