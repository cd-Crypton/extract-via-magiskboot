#!/bin/bash

source=$(pwd)
# Whats inside the IMG file?
unpack_img="unpack_img"
# Whats inside the main ramdisk file?
ramdisk="ramdisk"
# Whats inside the recovery ramdisk file?
rec_ramdisk="rec_ramdisk"

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
rm -rf $source/$unpack_img; mkdir -p $source/$unpack_img
rm -rf $source/$ramdisk; mkdir -p $source/$ramdisk
rm -rf $source/$rec_ramdisk; mkdir -p $source/$rec_ramdisk

# Unpack supplied .img file to $source/$unpack
cd $source/$unpack_img
echo " "
echo "Magisk Modification Tool - Unpack Script"
echo "by cd-Crypton"
echo " "
echo "Unpacking $1..."
sleep 3s
$source/bin/magiskboot unpack $source/$1 2>&1 | tee $source/$unpack_img/RAMDISK_INFO.txt

# Count CPIO archives.
COUNT_CPIO=$(find "$source/$unpack_img" -type f -name "*.cpio" | wc -l)
echo " "
if [[ "$COUNT_CPIO" == "1" ]]; then
    echo "Detected a single ramdisk image!"
    cpio_n="ramdisk.cpio"
    echo " "
fi

if [[ "$COUNT_CPIO" -ge 2 ]]; then
    echo "Detected multiple ramdisk images!"
    echo " "
fi

sleep 3s
# Extracting ramdisk into $source/$ramdisk
cd $source/$ramdisk
echo "Extracting vendor_ramdisk_.cpio..."
$source/bin/magiskboot cpio $source/$unpack_img/vendor_ramdisk_.cpio extract 2>/dev/null
sleep 3s
echo "Extracting vendor_ramdisk_recovery.cpio..."
cd $source/$rec_ramdisk
$source/bin/magiskboot cpio $source/$unpack_img/vendor_ramdisk_recovery.cpio extract 2>/dev/null
sleep 3s
echo " "
echo "Check $unpack_img/ for unpacked $1."
echo "Check $ramdisk/ for unpacked vendor_ramdisk_.cpio."
echo "Check $rec_ramdisk/ for unpacked vendor_ramdisk_recovery.cpio."
echo " "

