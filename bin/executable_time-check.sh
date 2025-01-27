#!/bin/bash
source ~/bin/life-common.sh

echo "Time Overview:"
echo "============="
echo "Local ($(TZ=$LOCAL_TZ date +%Z)): $(TZ=$LOCAL_TZ date '+%H:%M')"
echo "System ($(TZ=$SYSTEM_TZ date +%Z)): $(TZ=$SYSTEM_TZ date '+%H:%M')"
echo "Family ($(TZ=$FAMILY_TZ date +%Z)): $(TZ=$FAMILY_TZ date '+%H:%M')"
echo
echo "Current Block: $(~/bin/blocks.sh status | grep "Active tracking" -A 1)"
