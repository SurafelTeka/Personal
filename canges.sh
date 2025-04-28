#!/bin/bash

# Ensure we're in a Git repo
if [ ! -d ".git" ]; then
    echo "Error: .git directory not found!"
    exit 1
fi

# Define possible target files
FILES=(
    "index.html"
    "about.html"
    "contact.html"
    "assets/css/style.css"
    "assets/js/main.js"
    "README.md"
)

# Create missing files if they don't exist
for FILE in "${FILES[@]}"; do
    DIRNAME=$(dirname "$FILE")
    mkdir -p "$DIRNAME"
    if [ ! -f "$FILE" ]; then
        echo "<!-- Created $FILE -->" > "$FILE"
    fi
done

# List of realistic commit messages
MESSAGES=(
    "Improve homepage text"
    "Add about section paragraph"
    "Enhance contact form layout"
    "Refactor CSS for buttons"
    "Add comment to JavaScript function"
    "Update README with project details"
    "Fix small typo in about.html"
    "Polish UI spacing"
    "Add footer links"
    "Improve form validation"
)

# Function to modify files
modify_file() {
    FILE=$1
    case $FILE in
        *.html)
            echo "<p>New paragraph added $(date +%s)</p>" >> "$FILE"
            ;;
        *.css)
            echo ".new-class-$(date +%s) { margin: 10px; }" >> "$FILE"
            ;;
        *.js)
            echo "// New function added at $(date +%s)" >> "$FILE"
            ;;
        *.md)
            echo "- New update at $(date '+%Y-%m-%d %H:%M:%S')" >> "$FILE"
            ;;
        *)
            echo "# Random change $(date +%s)" >> "$FILE"
            ;;
    esac
}

# How many commits
TOTAL_COMMITS=15

# Date range: Oct 2, 2024 - Feb 15, 2025
START_DATE=$(date -d "2024-10-02" +%s)
END_DATE=$(date -d "2025-02-15" +%s)

# Create commits
for i in $(seq 1 $TOTAL_COMMITS); do
    FILE=${FILES[$RANDOM % ${#FILES[@]}]}
    modify_file "$FILE"

    git add "$FILE"
    MSG=${MESSAGES[$RANDOM % ${#MESSAGES[@]}]}

    # Random date within range
    RANDOM_TIMESTAMP=$((START_DATE + RANDOM % (END_DATE - START_DATE)))
    COMMIT_DATE=$(date -d "@$RANDOM_TIMESTAMP" "+%Y-%m-%dT%H:%M:%S")

    # Commit with custom date
    GIT_AUTHOR_DATE="$COMMIT_DATE" GIT_COMMITTER_DATE="$COMMIT_DATE" git commit -m "$MSG"

    echo "✅ Commit $i: Modified $FILE with message: '$MSG' at $COMMIT_DATE"
done

echo "🎉 Finished $TOTAL_COMMITS commits spread between October 2024 and February 2025!"
