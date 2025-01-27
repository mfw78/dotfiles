#!/bin/bash
source ~/bin/life-common.sh

DATE=$(TZ=$LOCAL_TZ date +%Y-%m-%d)
REVIEW_FILE="$JOURNAL_DIR/weekly-reviews/$DATE.md"
TEMPLATE="$TEMPLATE_DIR/weekly-review.md"

create_journal "$TEMPLATE" "$REVIEW_FILE" "$DATE"
launch_editor "$GRAPH_DIR" "$REVIEW_FILE"
