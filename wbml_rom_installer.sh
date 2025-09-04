#!/bin/bash
# Wonder Boy in Monster Land ROM Builder
set -euo pipefail

WORKING_DIR="$(pwd)"
OUTPUT_DIR="$WORKING_DIR/arcade/wbml"

ROM_FILES=("vc.ic4" "vc.ic5" "vc.ic6")
TILE_FILES=("wbmlvcd.ic90" "wbmlvcd.ic91" "wbmlvcd.ic92")
SPRITE_FILES=("epr11028.87" "epr11027.86" "epr11030.89" "epr11029.88")
SOUND_FILES=("epr11037.126")
PROM_FILES=("pr5317.37" "pr11025.14" "pr11024.8" "pr11026.20")

echo "+----------------------------------------------+"
echo "|  Building Wonderboy Monsterland Arcade ROMs  |"
echo "+----------------------------------------------+"

# Ensure directories
mkdir -p "$OUTPUT_DIR"

# Copy game ROMs
for file in "${TILE_FILES[@]}"; do
    cp "$WORKING_DIR/$file" "$OUTPUT_DIR/"
done
echo "Game ROMs copied"

# Build sprite ROM (concatenate)
cat "${SPRITE_FILES[@]/#/$WORKING_DIR/}" > "$OUTPUT_DIR/sprites.bin"
echo "Sprite ROM built"

# Copy sound ROM
for file in "${SOUND_FILES[@]}"; do
    cp "$WORKING_DIR/$file" "$OUTPUT_DIR/"
done
echo "Sound ROM copied"

# Split 32KB ROMs into two 16KB chunks
for rom in "${ROM_FILES[@]}"; do
    if [[ ! -f "$rom" ]]; then
        echo "Skipping $rom (not found)"
        continue
    fi
    dd if="$rom" of="$OUTPUT_DIR/${rom}_1" bs=16K count=1 status=none
    dd if="$rom" of="$OUTPUT_DIR/${rom}_2" bs=16K skip=1 count=1 status=none
    echo "Created $OUTPUT_DIR/${rom}_1 and ${rom}_2"
done

# Copy PROMs
for file in "${PROM_FILES[@]}"; do
    cp "$WORKING_DIR/$file" "$OUTPUT_DIR/"
done
echo "Lookup PROMs copied"

# Dump zeroed table (256 bytes of 0x00)
dd if=/dev/zero of="$OUTPUT_DIR/dectable.bin" bs=1 count=256 status=none
echo "Table dumped"

# Create empty wbmlcfg (73 bytes of 0xFF)
printf '\xFF%.0s' {1..75} > "$OUTPUT_DIR/wbmlcfg"
echo "Blank wbmlcfg created"

echo "All done!"
