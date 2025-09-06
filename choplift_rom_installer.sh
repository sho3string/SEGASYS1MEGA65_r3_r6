#!/bin/bash

echo "+------------------------------------+"
echo "|  Building Choplifter Arcade ROMs   |"
echo "+------------------------------------+"

# Set working and output directories
WORKDIR="$(pwd)"
OUTDIR="$WORKDIR/arcade/choplift"
mkdir -p "$OUTDIR"

# ROMs to split
ROM_FILES=("epr-7127.ic4" "epr-7128.ic5" "epr-7129.ic6")

# Copy tile ROMs
TILE_FILES=("epr-7152.ic90" "epr-7153.ic91" "epr-7154.ic92")
for file in "${TILE_FILES[@]}"; do
    cp "$WORKDIR/$file" "$OUTDIR/"
done
echo "Game ROMs copied"

# Build sprite ROM
SPRITE_FILES=("epr-7121.ic87" "epr-7120.ic86" "epr-7123.ic89" "epr-7122.ic88")
SPRITE_OUT="$OUTDIR/sprites.bin"
: > "$SPRITE_OUT"
for file in "${SPRITE_FILES[@]}"; do
    cat "$WORKDIR/$file" >> "$SPRITE_OUT"
done
echo "Sprite ROM built"

# Copy sound ROM
cp "$WORKDIR/epr-7130.ic126" "$OUTDIR/"
echo "Sound ROM copied"

# Split ROMs into 16KB chunks
CHUNK_SIZE=$((16 * 1024))
for rom in "${ROM_FILES[@]}"; do
    if [[ ! -f "$rom" ]]; then
        echo "Skipping $rom (file not found)"
        continue
    fi

    base=$(basename "$rom")
    dd if="$rom" bs=1 count=$CHUNK_SIZE of="$OUTDIR/${base}_1" status=none
    dd if="$rom" bs=1 skip=$CHUNK_SIZE count=$CHUNK_SIZE of="$OUTDIR/${base}_2" status=none
    echo "Created ${base}_1 and ${base}_2"
done

# Copy PROMs
PROM_FILES=("pr5317.ic28" "pr7118.ic14" "pr7117.ic8" "pr7119.ic20")
for file in "${PROM_FILES[@]}"; do
    cp "$WORKDIR/$file" "$OUTDIR/"
done
echo "Lookup PROMs copied"

# Dump decryption table (256 bytes of 0x00)
dd if=/dev/zero bs=1 count=256 of="$OUTDIR/dectable.bin" status=none
echo "Table dumped"

# Create blank CFG file (75 bytes of 0xFF)
yes '\xFF' | head -c 75 > "$OUTDIR/clcfg"
echo "Blank clcfg created"

echo "All done!"