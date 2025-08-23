#!/bin/bash

echo "+-----------------------------------+"
echo "|  Building Pitfall II Arcade ROMs  |"
echo "+-----------------------------------+"

WORKING_DIR=$(pwd)
OUTPUT_PATH="$WORKING_DIR/arcade/pitfall2"
mkdir -p "$OUTPUT_PATH"

# XOR Table for encryption (saved as binary)
XOR_HEX="A0 80 A8 88 A0 80 A8 88
		08 88 28 A8 28 A8 20 A0 
		A0 80 A8 88 A0 80 A8 88 
		A0 A8 20 28 A0 A8 20 28 
		A0 80 A8 88 20 00 A0 80 
		28 A8 20 A0 20 00 A0 80 
		A0 A8 20 28 A0 A8 20 28 
		28 A8 20 A0 A0 A8 20 28 
		20 00 A0 80 80 88 A0 A8 
		80 88 A0 A8 80 88 A0 A8 
		A0 A8 20 28 A0 80 A8 88 
		80 88 A0 A8 28 A8 20 A0 
		20 00 A0 80 80 88 A0 A8 
		80 88 A0 A8 20 00 A0 80 
		A0 A8 20 28 A0 80 A8 88 
		80 88 A0 A8 28 A8 20 A0"

echo "$XOR_HEX" | xxd -r -p > "$OUTPUT_PATH/xortable.bin"
echo "XOR table dumped"

# CPU ROM build
cat epr6456a.116 epr6457a.109 > "$OUTPUT_PATH/rom1.bin"
echo "CPU ROM built"

# Non-encrypted ROM
cp  epr6458a.96 "$OUTPUT_PATH/"
echo "Non-encrypted ROM copied"

# Sound ROM (same file twice)
cp  epr-6462.120 "$OUTPUT_PATH/"
echo "Sound ROM copied"

# Tile ROMs
for tile in epr6474a.62 epr6472a.64 epr6470a.66 epr6473a.61 epr6471a.63 epr6469a.65; do
    cp "$tile" "$OUTPUT_PATH/"
done
echo "Tile ROMs copied"

# Sprite ROM build (files duplicated)
cat epr6454a.117 epr-6455.05 epr6454a.117 epr-6455.05 > "$OUTPUT_PATH/sprites.bin"
echo "Sprite ROM built"

# Lookup PROM
cp pr-5317.76 "$OUTPUT_PATH/"
echo "Lookup PROM copied"

# Create blank udcfg (filled with 0xFF)
head -c 73 < /dev/zero | tr '\000' '\377' > "$OUTPUT_PATH/pf2cfg"
echo "Blank pf2cfg created"

echo "All done!"
