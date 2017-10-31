#!/bin/bash
gpu_status=$(cat /proc/acpi/bbswitch | cut -d ' ' -f 2)

echo $gpu_status
if [[  $gpu_status == "OFF" ]]; then
    exit 1
fi

exit 0
