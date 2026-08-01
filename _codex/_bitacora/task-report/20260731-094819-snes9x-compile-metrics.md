# snes9x compile — metrics

Date: 2026-07-31

## Result

Build succeeded. Binary runs.

## Binary

- Path: `_code-dives/snes9x-repo/snes9x/unix/snes9x`
- Size: 15,312,496 bytes (~14.6 MiB)
- Type: ELF 64-bit PIE, x86-64, dynamically linked, debug info, not stripped
- Version: Snes9x 1.63 for unix
- Commit: b5cc765 (depth 1)

## Toolchain

- g++/gcc (system), make, autoconf/automake, pkg-config
- Build system: autotools (`unix/configure`)

## Configure

```text
./configure --disable-sound --disable-netplay --disable-debugger
alsa support......... yes
screenshot support... yes
netplay support...... no
gamepad support...... yes
GZIP/ZIP/JMA support. yes
debugger............. no
```

## Compile flags

```text
-c -g -O2 -O3 -fomit-frame-pointer -fno-exceptions -fno-rtti -pedantic -Wall -W
-DJOYSTICK_SUPPORT -DZLIB -DUNZIP_SUPPORT -DSYSTEM_ZIP -DJMA_SUPPORT
-DHAVE_LIBPNG -DHAVE_MKSTEMP -DHAVE_STRINGS_H -DHAVE_SYS_IOCTL_H -DHAVE_STDINT_H
-DRIGHTSHIFT_IS_SAR -DUSE_XVIDEO -DUSE_LIBYUV -DUSE_XINERAMA -DALSA -DMITSHM
```

## Link libraries

```text
-lm -lz -lminizip -lpng -lSM -lICE -lX11 -lXext -lXv -lyuv -lXinerama -lasound
```

## Warnings (no errors)

- `filter/snes_ntsc.h:152` — deprecated enum arithmetic (NTSC filter constants)
- `bml.cpp:92,154` — sign-compare, `int` vs `string_view::size_type`
- `unix.cpp:167` — unused static `snes9x_log2`
- `x11.cpp:725` — sign-compare, `uint32` vs `int` (Xinerama heads)
- `x11.cpp:925` — calloc transposed args
- `x11.cpp:1601` — deprecated `XKeycodeToKeysym`
- `snes_ntsc.c` — `-fno-rtti` ignored for C (harmless)

## Verification

```text
./snes9x --help → usage text, options listed
```

## Log

`report/20260731-093528-snes9x-build.log` — full compile + link transcript (69 lines).

---

# Native build (instruction set) — 2026-07-31

## Result

Second build with the host instruction set (Intel i5-8350U, Kaby Lake R: SSE4.2/AVX2/FMA/BMI). Succeeded.

## Configure

```text
CFLAGS="-O3 -march=native" CXXFLAGS="-O3 -march=native" \
./configure --enable-sse41 --enable-avx2 --disable-netplay --disable-debugger
SSE4.1............... yes
AVX2................. yes
NEON................. no
options.............. -O3 -march=native -O3 -fomit-frame-pointer -fno-exceptions
                     -fno-rtti -pedantic -Wall -W -Wno-unused-parameter -msse4.1 -mavx2
```

## Compile metrics

| Metric | Generic build | Native build |
|---|---:|---:|
| Binary size | 15,312,496 B (14.6 MiB) | 2,746,376 B (2.6 MiB) |
| Wall time | — | 27.6 s |
| CPU time (8 threads) | — | 2 m 53.6 s |
| Debug info | yes (`-g`) | no |
| SSE4.1/AVX2 | no | yes |
| AVX2 vector instructions | — | 6,547 |
| Errors | 0 | 0 |
| Warnings | 7 | 7 (same set) |

## Size note

The native binary is 82% smaller because configure dropped `-g` (`--disable-debugger`), not because of `-march=native`.

## Command logs

```text
_bitacora/stdout/20260731-094601-snes9x-verify.log
_bitacora/stdout/20260731-094601-snes9x-file.log
_bitacora/stdout/20260731-094601-snes9x-avx2-count.log
_bitacora/stdout/20260731-094635-snes9x-avx2-check.log
_bitacora/stdout/20260731-094636-snes9x-help.log
```
