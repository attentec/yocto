#!/bin/bash
# This script is designed to be sourced from a script in the
# setup folder. This file do the common setup steps.

#!/bin/bash

LAYERS=(
"meta-oe/meta-oe"
"meta-oe/meta-python"
"meta-oe/meta-networking"
"meta-rpi"
)

MACHINE="raspberrypi3"

if [ -z "$LAYERS" ]; then
    echo "WARNING: layers variable not set prior to calling. Aborting."
elif [ -z "$MACHINE" ]; then
    echo "WARNING: machine variable not set prior to calling. Aborting."
else
    build_dir="build"

    export MACHINE
    #export DISTRO=${distro:-"alv-distro-release"}
    #export IMAGE=${image="alv-image-base"}
    # Set short sha1 hash and append dirty if uncommited changes
    REPO_SHA_STATUS="$(git log --oneline | head -1 | awk '{print $1}')"
    git diff-index --quiet HEAD || REPO_SHA_STATUS="${REPO_SHA_STATUS}-dirty"
    export REPO_SHA_STATUS
    export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE IMAGE SSTATE_DIR REPO_SHA_STATUS"

    # Make sure bblayers and local.conf do not contain traces of
    # previous builds by removing them. oe-init-build-env will
    # recreate them.
    rm -f ${build_dir}/conf/bblayers.conf
    rm -f ${build_dir}/conf/local.conf

    if [ -n "$SSTATE_DIR" ]; then
        echo "Using shared sstate @ $SSTATE_DIR"
    fi

    source layers/poky/oe-init-build-env ${build_dir} > /dev/null

    for ((i = 0; i < ${#LAYERS[@]}; i++))
    do
        echo Adding layer "${LAYERS[$i]}"
        bitbake-layers add-layer "../layers/${LAYERS[$i]}"
    done
    echo "Ready to work"
fi
