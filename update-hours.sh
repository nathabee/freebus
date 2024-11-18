#!/bin/bash

WORKLOG_FILE="documentation/WORKLOG.md"
README_FILE="README.md"   
 
# Check if the WORKLOG.md file exists, if not, exit with an error
if [ ! -f "$WORKLOG_FILE" ]; then
  echo "Error: WORKLOG.md file not found!"
  exit 1
fi

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

echo "Total hours calculated: ${total_hours}"

# Python script to update the markdown files
update_files() {
    local file=$1
    local total_hours=$2

    python3 << EOF
import re

file_path = "$file"
total_hours = "$total_hours"

with open(file_path, 'r') as file:
    content = file.read()

# Update the line containing Total Hours Worked
content = re.sub(
    r"(!\[⏱️\]\(.*?\) \*\*Total Hours Worked\*\*: _)([0-9]+ hours)(_ \(Auto-generated\))",
    r"\g<1>{} hours\g<3>".format(total_hours),
    content
)

with open(file_path, 'w') as file:
    file.write(content)

print(f"Updated {file_path} successfully.")
EOF
}

# Update WORKLOG.md
update_files "$WORKLOG_FILE" "$total_hours"

# Update README.md if it exists
if [ -f "$README_FILE" ]; then
    update_files "$README_FILE" "$total_hours"
else
    echo "Warning: README.md file not found!"
fi

echo "Script finished. Please verify changes."