#!/bin/bash

if mountpoint -q /mnt/usb; then
    echo '{"text": "", "tooltip": "/mnt/usb смонтирован"}'
else
    echo '{"text": ""}'
fi
