#!/usr/bin/env sh

mount -t proc none /proc
mount -t sysfs none /sys

hostname qemu

ip link set lo up

exec /bin/bash
