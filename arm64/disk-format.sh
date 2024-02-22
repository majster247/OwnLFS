#!bin/bash

#format disk (sd card) for arm64

mke2fs /dev/mmcblk0p1
mkswap /dev/mmcblk0p2


