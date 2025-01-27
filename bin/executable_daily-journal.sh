#!/bin/bash
source ~/bin/life-common.sh

DATE=$(TZ=$LOCAL_TZ date +%Y-%m-%d)
YESTERDAY=$(TZ=$LOCAL_TZ date -d "yesterday" +%Y-%m-%d)
JOURNAL_FILE="$JOURNAL_DIR/daily/$DATE.md"
TEMPLATE="$TEMPLATE_DIR/daily.md"

# Get completed tasks from yesterday
COMPLETED_YESTERDAY=$(task end.after:$YESTERDAY end.before:$DATE all +COMPLETED \
    rc.verbose=nothing rc.report.all.columns=description \
    rc.report.all.labels=Description 2>/dev/null | sed 's/^/- /')

# Get pending tasks due today
PENDING_TODAY=$(task due:today rc.verbose=nothing \
    rc.report.all.columns=description rc.report.all.labels=Description \
    2>/dev/null | sed 's/^/- /')

# Set defaults if empty
[ -z "$COMPLETED_YESTERDAY" ] && COMPLETED_YESTERDAY="- No tasks completed yesterday"
[ -z "$PENDING_TODAY" ] && PENDING_TODAY="- No tasks due today"

if create_journal "$TEMPLATE" "$JOURNAL_FILE" "$DATE"; then
    # Create temporary file for sed operations
    TMP_FILE=$(mktemp)
    cp "$JOURNAL_FILE" "$TMP_FILE"
    
    # Replace placeholders
    sed -i "s|{{completed_yesterday}}|$COMPLETED_YESTERDAY|g" "$TMP_FILE"
    sed -i "s|{{pending_today}}|$PENDING_TODAY|g" "$TMP_FILE"
    
    mv "$TMP_FILE" "$JOURNAL_FILE"
else
    echo "Journal for $DATE already exists"
fi

launch_editor "$GRAPH_DIR" "$JOURNAL_FILE"
