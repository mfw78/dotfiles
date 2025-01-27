#!/bin/bash
source ~/bin/life-common.sh

# Define topics
declare -A TOPICS=(
    ["workflow"]="Daily Workflow Guide"
    ["blocks"]="Time Block System"
    ["journal"]="Journal System"
    ["tasks"]="Task Management"
)

show_workflow() {
    echo -e "${BLUE}Daily Workflow Guide${NC}\n"

    echo -e "${CYAN}1. Morning Routine (07:00-$MORNING_BLOCK_START)${NC}"
    echo -e "   ${GREEN}Commands:${NC}"
    echo "   j        → Open today's journal"
    echo "   today    → Review today's tasks"
    echo "   now      → Check current time/block"
    echo -e "   ${RED}Goal: Plan day and set intentions${NC}\n"

    echo -e "${CYAN}2. Morning Technical Block ($MORNING_BLOCK_START-$MORNING_BLOCK_END)${NC}"
    echo -e "   ${GREEN}Commands:${NC}"
    echo "   bm       → Start morning block"
    echo "   track    → Track specific tasks"
    echo -e "   ${RED}Goal: Deep technical work${NC}\n"

    echo -e "${CYAN}3. Flex Block ($FLEX_BLOCK_START-$FLEX_BLOCK_END)${NC}"
    echo -e "   ${GREEN}Commands:${NC}"
    echo "   bf       → Start flex block"
    echo "   track    → Track activities"
    echo -e "   ${RED}Goal: Family calls or reallocation${NC}\n"

    echo -e "${CYAN}4. Protected Time ($FLEX_BLOCK_END-$EVENING_BLOCK_START)${NC}"
    echo -e "   ${RED}Goal: Life activities, exercise, errands${NC}\n"

    echo -e "${CYAN}5. Evening Technical ($EVENING_BLOCK_START-$EVENING_BLOCK_END)${NC}"
    echo -e "   ${GREEN}Commands:${NC}"
    echo "   be       → Start evening block"
    echo "   track    → Track specific tasks"
    echo -e "   ${RED}Goal: Technical work completion${NC}\n"

    echo -e "${CYAN}6. Day End ($EVENING_BLOCK_END)${NC}"
    echo -e "   ${GREEN}Commands:${NC}"
    echo "   bs       → Stop tracking"
    echo "   j        → Complete daily journal"
    echo "   summary  → Review day's tracking"
    echo -e "   ${RED}Goal: Reflect and prepare for tomorrow${NC}\n"

    echo -e "${CYAN}Weekly Routine${NC}"
    echo "   Saturday morning: Weekly review (jr)"
    echo "   Plan next week's flex blocks"
    echo "   Review completed tasks"
    echo -e "   Set next week's priorities\n"

    echo -e "${YELLOW}Tips for Building Habits:${NC}"
    echo "1. Start each day with journal review"
    echo "2. Always track your time blocks"
    echo "3. Protect your life blocks"
    echo "4. Complete daily journal entries"
    echo "5. Don't skip weekly reviews"
}

show_blocks() {
    echo -e "${GREEN}Time Blocks:${NC}"
    echo -e "${CYAN}Morning Block${NC}  $MORNING_BLOCK_START-$MORNING_BLOCK_END (bm)"
    echo "- Deep technical work"
    echo -e "- High focus tasks\n"

    echo -e "${CYAN}Flex Block${NC}    $FLEX_BLOCK_START-$FLEX_BLOCK_END (bf)"
    echo "- Family calls ($FAMILY_TZ evening)"
    echo -e "- Reallocation as needed\n"

    echo -e "${CYAN}Evening Block${NC}  $EVENING_BLOCK_START-$EVENING_BLOCK_END (be)"
    echo "- Technical work"
    echo -e "- Documentation/planning\n"

    echo -e "${RED}Protected Blocks:${NC}"
    echo "07:00-$MORNING_BLOCK_START  - Morning routine"
    echo "$FLEX_BLOCK_END-$EVENING_BLOCK_START  - Life activities"
    echo "$EVENING_BLOCK_END-23:00  - Wind down"
}

show_journal() {
    echo -e "${GREEN}Journal System:${NC}"
    echo -e "${CYAN}Daily Journal (j)${NC}"
    echo "- Morning review"
    echo "- Task tracking"
    echo "- Flex block allocation"
    echo -e "- End of day reflection\n"

    echo -e "${CYAN}Weekly Review (jr)${NC}"
    echo "- Task completion analysis"
    echo "- Time block effectiveness"
    echo "- Next week planning"
    echo "- Personal reflection"
}

show_tasks() {
    echo -e "${GREEN}Task Management:${NC}"
    echo -e "${CYAN}Daily Tasks${NC}"
    echo "today     - View today's tasks"
    echo "tomorrow  - View tomorrow's tasks"
    echo -e "upcoming  - View future tasks\n"

    echo -e "${CYAN}Time Tracking${NC}"
    echo "track \"X\" - Start tracking task"
    echo "untrack   - Stop tracking"
    echo "summary   - View today's summary"
    echo "week      - View weekly summary"
}

show_help() {
    echo -e "${BLUE}Life Management System Help${NC}\n"
    
    echo -e "${YELLOW}Quick Help: lh [workflow|blocks|journal|tasks]${NC}\n"
    
    echo -e "${GREEN}Time Blocks:${NC}"
    echo "bm          - Start morning block ($MORNING_BLOCK_START-$MORNING_BLOCK_END)"
    echo "bf          - Start flex block ($FLEX_BLOCK_START-$FLEX_BLOCK_END)"
    echo "be          - Start evening block ($EVENING_BLOCK_START-$EVENING_BLOCK_END)"
    echo "bs          - Stop current block"
    echo -e "bstatus     - Show current block status\n"
    
    echo -e "${GREEN}Journal Commands:${NC}"
    echo "j           - Open today's journal"
    echo "jr          - Open weekly review"
    echo "jl N        - Open journal from N days ago"
    echo -e "wr N        - Open weekly review from N weeks ago\n"
    
    echo -e "${GREEN}Task Management:${NC}"
    echo "today       - Show today's tasks"
    echo "tomorrow    - Show tomorrow's tasks"
    echo "upcoming    - Show future tasks"
    echo "track \"X\"   - Start tracking specific task"
    echo -e "untrack     - Stop tracking current task\n"
    
    echo -e "${GREEN}Time Tracking:${NC}"
    echo "summary     - Show today's time tracking"
    echo -e "week        - Show this week's tracking\n"
    
    echo -e "${GREEN}Status Commands:${NC}"
    echo "now         - Show current time and block"
    echo -e "time-check  - Show all relevant timezones\n"
    
    echo -e "${GREEN}Help Commands:${NC}"
    echo "life-help   - Show this help"
    echo "lh          - Short alias for life-help"
    echo -e "lh workflow - Show daily workflow guide\n"
    
    echo -e "${YELLOW}Tip: All commands respect $LOCAL_TZ timezone${NC}"
}

# Main script logic
main() {
    local topic=${1:-help}
    
    case "$topic" in
        workflow|blocks|journal|tasks)
            echo -e "${BLUE}${TOPICS[$topic]}${NC}\n"
            show_$topic
            ;;
        *)
            show_help
            ;;
    esac
}

main "$@"
