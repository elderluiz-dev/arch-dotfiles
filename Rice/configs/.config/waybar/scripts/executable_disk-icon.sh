#!/bin/bash

if mountpoint -q /mnt/d1; then
    echo '{"text": "", "tooltip": "/mnt/d1 смонтирован"}'
else
    echo '{"text": ""}'
fi
