#!/bin/bash

# Source configuration
source ~/.config/life/config

# ANSI color codes
export BLUE='\033[0;34m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export RED='\033[0;31m'
export CYAN='\033[0;36m'
export NC='\033[0m'  # No Color

# Common time handling functions
get_current_time() {
    TZ=$LOCAL_TZ date "+%H%M"
}

get_current_block() {
    local time=$(get_current_time)
    
    if [ $time -ge $MORNING_BLOCK_START ] && [ $time -lt $MORNING_BLOCK_END ]; then
        echo "morning"
    elif [ $time -ge $FLEX_BLOCK_START ] && [ $time -lt $FLEX_BLOCK_END ]; then
        echo "flex"
    elif [ $time -ge $EVENING_BLOCK_START ] && [ $time -lt $EVENING_BLOCK_END ]; then
        echo "evening"
    else
        echo "protected"
    fi
}

get_tracking_status() {
    local current=$(timew | head -n 1)
    if [[ $current == "There is no active time tracking." ]]; then
        echo "⏸️ idle"
    else
        local task_name=$(echo $current | sed 's/Tracking //' | cut -c1-20)
        [[ ${#task_name} -gt 20 ]] && task_name="${task_name}..."
        echo "⏺️ ${task_name}"
    fi
}

start_time_block() {
    local block_name=$1
    timew stop >/dev/null 2>&1
    timew start "$block_name" $FOCUS_TAG
}

# Notification helper
notify() {
    local title=$1
    local message=$2
    notify-send "$title" "$message" -t $NOTIFICATION_TIMEOUT
}

# Journal helpers
create_journal() {
    local template=$1
    local output=$2
    local date=$3
    
    if [ ! -f "$output" ]; then
        sed "s/{{date}}/$date/g" "$template" > "$output"
        return 0
    fi
    return 1
}

# Editor launcher
launch_editor() {
    local workspace=$1
    local file=$2
    zeditor "$workspace" "$file"
}

format_task_list() {
    local tasks=$1
    [ -z "$tasks" ] && echo "- No tasks found"
    echo "$tasks" | sed 's/^/- /'
}

get_task_list() {
    local filter=$1
    task $filter rc.verbose=nothing \
        rc.report.all.columns=description \
        rc.report.all.labels=Description 2>/dev/null
}

validate_time_block() {
    local block=$1
    case $block in
        morning|flex|evening) return 0 ;;
        *) return 1 ;;
    esac
}

