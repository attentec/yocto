A repo to try yocto on a raspberryPi 3!

## Install
Clone this repo:
> git clone git@github.com:attentec/yocto.git

Enter cloned repo and clone depencies:
> cd yocto/
> git clone -b morty git://git.yoctoproject.org/poky layers/poky
> git clone -b morty git://git.openembedded.org/meta-openembedded layers/meta-oe
> git clone -b morty git://git.yoctoproject.org/meta-raspberrypi layers/meta-rpi


## Init
Init build environment with init script (will move you into build directory)
> source init.sh

## Build
Build the minimal hwup image from Raspberry Pi layer
> bitbake rpi-hwup-image

## Load to card and have fun
dd to a SD card the generated sdimg file (use xzcat if rpi-sdimg.xz is used)
Boot your RPI.
