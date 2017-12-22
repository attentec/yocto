#!/bin/bash
# This script is designed to be sourced from a machine specific 
# script. This file do the common setup steps.

if [ -z "$LAYERS" ]; then
    echo "WARNING: layers variable not set prior to calling. Aborting."
elif [ -z "$MACHINE" ]; then
    echo "WARNING: machine variable not set prior to calling. Aborting."
else
    build_dir="build"

    export MACHINE
    # Set short sha1 hash and append dirty if uncommited changes
    REPO_SHA_STATUS="$(git log --oneline | head -1 | awk '{print $1}')"
    git diff-index --quiet HEAD || REPO_SHA_STATUS="${REPO_SHA_STATUS}-dirty"
    export REPO_SHA_STATUS
    export BB_ENV_EXTRAWHITE="$BB_ENV_EXTRAWHITE REPO_SHA_STATUS"

    # Make sure bblayers and local.conf do not contain traces of
    # previous builds by removing them. oe-init-build-env will
    # recreate them.
    rm -f ${build_dir}/conf/bblayers.conf
    rm -f ${build_dir}/conf/local.conf

    source layers/poky/oe-init-build-env ${build_dir} > /dev/null

    for ((i = 0; i < ${#LAYERS[@]}; i++))
    do
        echo Adding layer "${LAYERS[$i]}"
        bitbake-layers add-layer "../layers/${LAYERS[$i]}"
    done
    echo "Ready to work for ${MACHINE}"
fi
