#!/bin/sh
# train.sh CORE FRAMES: PGO training run over all emulated models
C=$1; FR=$2
export LD_LIBRARY_PATH=/mnt/SDCARD/Koriki/lib:/lib:/config/lib:/customer/lib LR_RATE=48000
OPT=/mnt/SDCARD/RetroArch/.retroarch/config/SameBoy/SameBoy.opt
GBC=$(ls /mnt/SDCARD/Roms/GBC/*.gbc | head -1); GB=$(ls /mnt/SDCARD/Roms/GB/*.gb | head -1)
rm -rf /tmp/pgo; mkdir -p /tmp/pgo
mk() { grep -v '^sameboy_model ' $OPT > /tmp/sb/m.opt; echo "sameboy_model = \"$1\"" >> /tmp/sb/m.opt; }
mk "Auto";           /tmp/sb/lrbench $C "$GBC" $FR /tmp/sb/m.opt | tail -1
mk "Auto";           /tmp/sb/lrbench $C "$GB"  $FR /tmp/sb/m.opt | tail -1
mk "Super Game Boy"; /tmp/sb/lrbench $C "$GB"  $FR /tmp/sb/m.opt | tail -1
mk "Game Boy Color"; /tmp/sb/lrbench $C "$GB"  $FR /tmp/sb/m.opt | tail -1
find /tmp/pgo -name "*.gcda" | wc -l
echo fin
