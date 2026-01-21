#!/bin/bash
# Partition a directory into multiple zip files of max 30MB each
# Usage: ./partition_zip.sh <directory_name>

DIR="$1"
MAX_SIZE=$((30 * 1024 * 1024))  # 30MB in bytes

if [ -z "$DIR" ] || [ ! -d "$DIR" ]; then
    echo "Usage: $0 <directory_name>"
    exit 1
fi

cd "$DIR" || exit 1

# Get all files AND symlinks, sorted by path for reproducibility
mapfile -t ALL_FILES < <(find . \( -type f -o -type l \) | sort)

# Also find empty directories (directories with no files/subdirs with files)
mapfile -t EMPTY_DIRS < <(find . -type d -empty | sort)

TOTAL_FILES=${#ALL_FILES[@]}
TOTAL_EMPTY_DIRS=${#EMPTY_DIRS[@]}
echo "Processing $DIR: $TOTAL_FILES files/symlinks, $TOTAL_EMPTY_DIRS empty directories"

if [ "$TOTAL_FILES" -eq 0 ] && [ "$TOTAL_EMPTY_DIRS" -eq 0 ]; then
    echo "No files found in $DIR"
    exit 0
fi

PART=1
CURRENT_ZIP="../${DIR}_p${PART}.zip"
FILES_IN_PART=0

# First add all empty directories to the first zip (they're tiny)
for EDIR in "${EMPTY_DIRS[@]}"; do
    # Add directory entry to zip
    zip -qy "$CURRENT_ZIP" "$EDIR/" 2>/dev/null
done

for FILE in "${ALL_FILES[@]}"; do
    # Add file to current zip (-y preserves symlinks)
    zip -qy "$CURRENT_ZIP" "$FILE" 2>/dev/null
    FILES_IN_PART=$((FILES_IN_PART + 1))

    # Check zip size
    if [ -f "$CURRENT_ZIP" ]; then
        CURRENT_SIZE=$(stat -c%s "$CURRENT_ZIP")
    else
        CURRENT_SIZE=0
    fi

    # If over limit and more than 1 file in this part, move to next part
    if [ "$CURRENT_SIZE" -gt "$MAX_SIZE" ] && [ "$FILES_IN_PART" -gt 1 ]; then
        # Remove the file we just added
        zip -dq "$CURRENT_ZIP" "$FILE" 2>/dev/null
        FILES_IN_PART=$((FILES_IN_PART - 1))

        FINAL_SIZE=$(stat -c%s "$CURRENT_ZIP")
        echo "  Part $PART: $FILES_IN_PART files, $((FINAL_SIZE / 1024 / 1024))MB (${FINAL_SIZE} bytes)"

        # Start new part
        PART=$((PART + 1))
        CURRENT_ZIP="../${DIR}_p${PART}.zip"
        FILES_IN_PART=0

        # Add the file to the new part
        zip -qy "$CURRENT_ZIP" "$FILE" 2>/dev/null
        FILES_IN_PART=$((FILES_IN_PART + 1))
    fi
done

# Report final part
if [ -f "$CURRENT_ZIP" ]; then
    FINAL_SIZE=$(stat -c%s "$CURRENT_ZIP")
    echo "  Part $PART: $FILES_IN_PART files, $((FINAL_SIZE / 1024 / 1024))MB (${FINAL_SIZE} bytes)"
fi

cd ..
echo "Created $PART zip file(s) for $DIR"
