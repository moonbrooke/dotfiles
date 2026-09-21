#!/bin/bash

set -e

AVAILABLE_CATEGORIES=(
    "AudioVideo"
    "Audio"
    "Video"
    "Development"
    "Education"
    "HealthFitness"
    "Game"
    "Graphics"
    "Network"
    "Office"
    "Science"
    "Settings"
    "System"
    "Utility"
)

echo "=== .desktop File Generator ==="
echo

while [[ -z "$APP_NAME" ]]; do
    read -p "App Name: " APP_NAME
done

read -p "Desc. (optional, press Enter to skip): " GENERIC_NAME

while [[ -z "$EXEC_PATH" ]]; do
    read -p "Path to Exec: " EXEC_PATH
    # Expand tilde if present
    EXEC_PATH="${EXEC_PATH/#\~/$HOME}"
    if [[ ! -f "$EXEC_PATH" ]]; then
        echo "Warning: File '$EXEC_PATH' does not exist. Proceeding anyway..."
    fi
done

read -p "Path to Icon (optional, press Enter to skip): " ICON_PATH
ICON_PATH="${ICON_PATH/#\~/$HOME}"

echo "Run in Terminal?"
select term_choice in "false" "true"; do
    case $term_choice in
        "false"|"true")
            TERMINAL="$term_choice"
            break
            ;;
        *)
            echo "Invalid option. Please choose 1 or 2."
            ;;
    esac
done

echo
echo "Categories (enter numbers separated by space, e.g., '1 4 14'):"
for i in "${!AVAILABLE_CATEGORIES[@]}"; do
    printf "%2d) %s\n" $((i + 1)) "${AVAILABLE_CATEGORIES[$i]}"
done

SELECTED_CATEGORIES=""
while [[ -z "$SELECTED_CATEGORIES" ]]; do
    read -p "Category choices: " -a CHOICES
    
    TEMP_CATEGORIES=""
    for choice in "${CHOICES[@]}"; do
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#AVAILABLE_CATEGORIES[@]}" ]; then
            INDEX=$((choice - 1))
            TEMP_CATEGORIES="${TEMP_CATEGORIES}${AVAILABLE_CATEGORIES[$INDEX]};"
        else
            echo "Invalid selection: $choice. Please try again."
            TEMP_CATEGORIES=""
            break
        fi
    done
    
    SELECTED_CATEGORIES="$TEMP_CATEGORIES"
done

echo
while [[ -z "$FILE_NAME" ]]; do
    read -p "Enter .desktop file name (e.g., myapp or myapp.desktop): " FILE_NAME
done

if [[ "$FILE_NAME" != *.desktop ]]; then
    FILE_NAME="${FILE_NAME}.desktop"
fi

DESKTOP_CONTENT="[Desktop Entry]
Type=Application
Name=${APP_NAME}"

if [[ -n "$GENERIC_NAME" ]]; then
    DESKTOP_CONTENT="${DESKTOP_CONTENT}
GenericName=${GENERIC_NAME}"
fi

DESKTOP_CONTENT="${DESKTOP_CONTENT}
Exec=${EXEC_PATH}
Terminal=${TERMINAL}
Categories=${SELECTED_CATEGORIES}"

if [[ -n "$ICON_PATH" ]]; then
    DESKTOP_CONTENT="${DESKTOP_CONTENT}
Icon=${ICON_PATH}"
fi

TARGET_DIR="$HOME/.local/share/applications"
mkdir -p "$TARGET_DIR"

TARGET_PATH="${TARGET_DIR}/${FILE_NAME}"

echo "$DESKTOP_CONTENT" > "$TARGET_PATH"
chmod +x "$TARGET_PATH"

echo
echo "Successfully created and copied to:"
echo "  $TARGET_PATH"
echo
echo "Content preview:"
echo "----------------------------------------"
cat "$TARGET_PATH"
echo "----------------------------------------"
