#!/bin/bash
source ~/bin/life-common.sh

options="Start Morning Block
Start Flex Block
Start Evening Block
Stop Current Block
View Status
Track Task"

selected=$(echo -e "$options" | wofi --dmenu --prompt "Time Block Management" --cache-file /dev/null)

case $selected in
    "Start Morning Block")
        start_time_block "$MORNING_BLOCK_NAME"
        notify "Started Morning Block" "Technical focus time ($MORNING_BLOCK_START-$MORNING_BLOCK_END)"
        ;;
    "Start Flex Block")
        start_time_block "$FLEX_BLOCK_NAME"
        notify "Started Flex Block" "Family/Variable time ($FLEX_BLOCK_START-$FLEX_BLOCK_END)"
        ;;
    "Start Evening Block")
        start_time_block "$EVENING_BLOCK_NAME"
        notify "Started Evening Block" "Technical work ($EVENING_BLOCK_START-$EVENING_BLOCK_END)"
        ;;
    "Stop Current Block")
        timew stop
        notify "Stopped Block" "Ended time tracking"
        ;;
    "View Status")
        status=$(timew summary :day)
        notify "Time Block Status" "$status"
        ;;
    "Track Task")
        task=$(wofi --dmenu --prompt "Enter task description:" --cache-file /dev/null)
        if [ ! -z "$task" ]; then
            timew stop
            timew start "$task"
            notify "Tracking Task" "Now tracking: $task"
        fi
        ;;
esac
