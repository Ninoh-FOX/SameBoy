# PGO profile for the Miyoo Mini build

`obj/` holds the GCC profile (`.gcda`) recorded on a Miyoo Mini Plus at 1200 MHz.
`make platform=miyoomini` copies it into `build/obj/` and builds with
`-fprofile-use`. It only matches the current sources: after changing any C file,
record it again (GCC silently ignores the profile of functions that changed).

Toolchain: `/opt/miyoomini-toolchain` (GCC 8.3).

## Build

    export PATH=/opt/miyoomini-toolchain/bin:$PATH
    cd libretro
    make platform=miyoomini CC=arm-linux-gnueabihf-gcc BOOTROMS_DIR=../BootROMs/prebuilt
    arm-linux-gnueabihf-strip sameboy_libretro.so

`PGO=0` builds without the profile.

## Recording the profile again

1. Build the instrumented core: `make clean; make platform=miyoomini PGO=generate ...`
2. Build the headless runner: `arm-linux-gnueabihf-gcc -O2 -Ilibretro-common/include -o lrbench pgo/miyoomini/lrbench.c -ldl`
3. Copy `sameboy_libretro.so`, `lrbench` and `train.sh` to `/tmp/sb/` on the device and run
   `/tmp/sb/train.sh /tmp/sb/sameboy_libretro.so 1800`. It runs a GBC game and a GB game
   as CGB, DMG, SGB and GB-on-CGB, so every model's code paths get profiled.
4. The profile is written to `/tmp/build/obj/` on the device. Copy that tree to
   `pgo/miyoomini/obj/` and rebuild normally.

`lrbench` also measures speed: `lrbench core.so rom frames [core.opt]` prints fps and
CRCs of the video and audio output (handy to check that a change keeps the output identical).
Set `LR_RATE=48000` to report the frontend sample rate like RetroArch does.
