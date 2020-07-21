#!/bin/bash

set -ex
set -o pipefail

check_if_setup_file_exists() {
    if [ ! -f setup.py ]; then
        echo "setup.py must exist in the directory that is being packaged and published."
        exit 1
    fi
}

go_to_build_dir() {
    if [ ! -z $INPUT_SUBDIR ]; then
        cd $INPUT_SUBDIR
    fi
}

check_if_meta_yaml_file_exists() {
    if [ ! -f meta.yaml ]; then
        echo "meta.yaml must exist in the directory that is being packaged and published."
        exit 1
    fi
}

build_package() {
    # Build for Linux
    mamba build . --output-folder .
}

install_package() {
    mamba install --use-local $PACKAGE_NAME
}

upload_package(){
    # Convert to other platforms: OSX, WIN
    if [[ $INPUT_PLATFORMS == *"osx"* ]]; then
    mamba convert -p osx-64 linux-64/*.tar.bz2
    fi
    if [[ $INPUT_PLATFORMS == *"win"* ]]; then
    mamba convert -p win-64 linux-64/*.tar.bz2
    fi

    export ANACONDA_API_TOKEN=$INPUT_ANACONDATOKEN
    if [[ $INPUT_PLATFORMS == *"osx"* ]]; then
    anaconda upload --label main osx-64/*.tar.bz2
    fi
    if [[ $INPUT_PLATFORMS == *"linux"* ]]; then
    anaconda upload --label main linux-64/*.tar.bz2
    fi
    if [[ $INPUT_PLATFORMS == *"win"* ]]; then
    anaconda upload --label main win-64/*.tar.bz2
    fi
}

check_if_setup_file_exists
go_to_build_dir
check_if_meta_yaml_file_exists
build_package
upload_package
