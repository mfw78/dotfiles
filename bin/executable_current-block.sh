#!/bin/bash
source ~/bin/life-common.sh

block=$(get_current_block)
tracking=$(get_tracking_status)

case $block in
    "morning")
        echo "{\"text\": \"☕ Morning | ${tracking}\", \"class\": \"morning\", \"tooltip\": \"Morning Technical Block ($MORNING_BLOCK_START-$MORNING_BLOCK_END)\"}"
        ;;
    "flex")
        echo "{\"text\": \"🕐 Flex | ${tracking}\", \"class\": \"flex\", \"tooltip\": \"Flex Block ($FLEX_BLOCK_START-$FLEX_BLOCK_END)\"}"
        ;;
    "evening")
        echo "{\"text\": \"🌙 Evening | ${tracking}\", \"class\": \"evening\", \"tooltip\": \"Evening Technical Block ($EVENING_BLOCK_START-$EVENING_BLOCK_END)\"}"
        ;;
    *)
        echo "{\"text\": \"🛡️ Protected | ${tracking}\", \"class\": \"protected\", \"tooltip\": \"Protected Time Block\"}"
        ;;
esac
