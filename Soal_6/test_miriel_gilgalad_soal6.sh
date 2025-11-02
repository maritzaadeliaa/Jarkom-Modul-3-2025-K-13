#!/bin/bash
set -e

dhclient -r eth0
grep lease /var/lib/dhcp/dhclient.leases | tail -5
# Harus muncul value 1800.
