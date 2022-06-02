#!/bin/bash

cp ../build/buildroot-2022.02.1/output/images/uImage images
cp ../build/buildroot-2022.02.1/output/images/u-boot.bin images
sudo nuwriter run.ini
