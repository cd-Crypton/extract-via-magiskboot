#!/bin/bash

source=$(pwd)
unpack="unpack_root"
ramdisk="ramdisk_root"

# Exit if $1 were not given
if [[ -z "$1" ]]; then
    echo "Usage: bash unpack.sh <target_image.img>"
    exit 1
fi

# Exit if the supplied value is not .img file.
if [[ "$1" != *.img ]]; then
    echo "Usage: bash unpack.sh <target_image.img>"
    exit 1
fi

# Clean up and create necessary directories
echo "Cleaning up directories before we start..."
sleep 2s
rm -rf $source/$unpack; mkdir -p $source/$unpack
rm -rf $source/$ramdisk; mkdir -p $source/$ramdisk

# Unpack supplied .img file to $source/$unpack
cd $source/$unpack
echo " "
echo "Magisk Modification Tool - Unpack Script"
echo "by cd-Crypton"
echo " "
echo "Unpacking $1..."
sleep 3s
$source/bin/magiskboot unpack $source/$1 2>&1 | tee $source/$unpack/RAMDISK_INFO.txt

# Count CPIO archives.
COUNT_CPIO=$(find "$source/$unpack" -type f -name "*.cpio" | wc -l)

if [[ "$COUNT_CPIO" == "1" ]]; then
    echo "Detected a single ramdisk image!"
    cpio_n="ramdisk.cpio"
fi

if [[ "$COUNT_CPIO" == "2" || "$COUNT_CPIO" == "3" ]]; then
    echo "Detected multiple ramdisk images!"
    cpio_n="vendor_ramdisk_recovery.cpio"
fi

# Extracting ramdisk into $source/$ramdisk
cd $source/$ramdisk
echo "Extracting $cpio_n..."
$source/bin/magiskboot cpio $source/$unpack/$cpio_n extract 2>/dev/null
echo " "
echo "Check $unpack/ for unpacked $1."
echo "Check $ramdisk/ for unpacked $cpio_n."
echo " "

