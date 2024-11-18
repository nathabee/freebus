#!/bin/bash

WORKLOG_FILE="documentation/WORKLOG.md"
README_FILE="README.md"

# Extract total hours worked from WORKLOG.md
total_hours=0

# Read through the worklog file to add up all the "Hours Worked" lines
while IFS= read -r line
do
    if [[ "$line" =~ \*\*Hours\ Worked\*\*:\ ([0-9]+)\ hours ]]; then
        hours="${BASH_REMATCH[1]}"
        total_hours=$((total_hours + hours))
    fi
done < "$WORKLOG_FILE"

# Update WORKLOG.md file with the new total hours
sed -i "s/\\(Total Hours Worked\\):.*(Auto-generated)/\\1: _${total_hours} hours_ (Auto-generated)/" "$WORKLOG_FILE"

# Update README.md file with the new total hours
if grep -q "Total Hours Worked" "$README_FILE"; then
    # Update existing total hours line in README.md
    sed -i "s/\\(Total Hours Worked\\):.*(Auto-generated)/\\1: _${total_hours} hours_ (Auto-generated)/" "$README_FILE"
else
    # Add a new total hours line in README.md if it doesn't exist
    echo "" >> "$README_FILE"
    echo "![⏱️](https://img.icons8.com/emoji/48/stopwatch-emoji.png) **Total Hours Worked**: _${total_hours} hours_ (Auto-generated)" >> "$README_FILE"
fi

echo "Updated worklog and README with total hours: ${total_hours} hours."
