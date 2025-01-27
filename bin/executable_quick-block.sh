#!/bin/bash
source ~/bin/life-common.sh

current_block=$(get_current_block)

case $current_block in
    "morning")
        start_time_block "$MORNING_BLOCK_NAME"
        notify "Started Morning Block" "Technical focus time ($MORNING_BLOCK_START-$MORNING_BLOCK_END)"
        ;;
    "flex")
        start_time_block "$FLEX_BLOCK_NAME"
        notify "Started Flex Block" "Family/Variable time ($FLEX_BLOCK_START-$FLEX_BLOCK_END)"
        ;;
    "evening")
        start_time_block "$EVENING_BLOCK_NAME"
        notify "Started Evening Block" "Technical work ($EVENING_BLOCK_START-$EVENING_BLOCK_END)"
        ;;
    *)
        notify "Protected Time Block" "Focus on life activities"
        ;;
esac
