#!/bin/bash
set -e

LINUX_VERSION=6.1-rc3
LINUX=linux-${LINUX_VERSION}

BUSYBOX_VERSION=1.35.0
BUSYBOX=busybox-${BUSYBOX_VERSION}

QEMU_VERSION=7.1.0
QEMU=qemu-${QEMU_VERSION}


function info() {
    green='\033[0;32m'
    coff='\033[0m'
    echo -e "${green}[i] $1 ${coff}"
}


function install_dependencies() {
    sudo apt install build-essential gcc-aarch64-linux-gnu bison flex \
                     bc libncurses-dev libssl-dev ninja-build \
                     libpixman-1-dev libglib2.0-dev -yq
}

function build_linux() {
    info "downloading ${LINUX}.tar.gz..."
    curl -sLO https://git.kernel.org/torvalds/t/${LINUX}.tar.gz

    info "decompressing ${LINUX}.tar.gz..."
    tar zxf ${LINUX}.tar.gz

    info "Building config"
    cd ${LINUX}
    make ARCH=arm64 defconfig

    info "Building Linux kernel with $(nproc) cores"
    yes | make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image -j$(nproc)

    cd ..
    cp ${LINUX}/{vmlinux,arch/arm64/boot/Image} dbglinux/
}

function build_busybox() {
    info "downloading ${BUSYBOX}"
    curl -sLO https://busybox.net/downloads/${BUSYBOX}.tar.bz2

    info "decompressing ${BUSYBOX}.tar.gz..."
    tar jxf ${BUSYBOX}.tar.bz2

    info "building config"
    cd ${BUSYBOX}
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig
    echo "CONFIG_STATIC=y" >> .config # build as static binary 

    info "building busybox"
    make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- install -j$(nproc)

    info "creating initramfs"
    mkdir -p initramfs && cd initramfs
    mkdir -pv {bin,sbin,etc,proc,sys,usr/{bin,sbin}}
    cp -a ../_install/* .
    cp ../../init .
    chmod +x init
    find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../../dbglinux/initramfs.cpio.gz
    cd ../../
}

function build_qemu() {
    info "downloading ${QEMU}"
    curl -sLO https://download.qemu.org/${QEMU}.tar.xz

    info "decompressing ${QEMU}"
    tar Jxf ${QEMU}.tar.xz
    cd ${QEMU}

    info "configuring for aarch64"
    ./configure --target-list=aarch64-softmmu

    info "building ${QEMU}"
    make -j$(nproc)

    info "installing ${QEMU}"
    sudo make install
}

info "installing dependencies..."
install_dependencies

info "creating dbglinux dir"
mkdir -p dbglinux

info "building Linux..."
build_linux

info "building busybox..."
build_busybox

info "building qemu..."
build_qemu
