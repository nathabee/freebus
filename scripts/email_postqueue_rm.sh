postqueue -p | awk '($1 ~ /^[A-F0-9]+[*]?$/) { gsub("\\*", "", $1); print $1 }' | xargs -I {} sudo postsuper -d {}

postqueue -p | awk '($1 ~ /^[A-F0-9]+$/) { print $1 }' | xargs -I {} sudo postsuper -d {}
