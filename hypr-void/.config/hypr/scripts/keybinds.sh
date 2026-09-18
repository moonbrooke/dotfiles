#!/bin/bash

KEYSTXT="$HOME/.config/hypr/scripts/keybindings.txt"
ROFI_THEME="$HOME/.config/rofi/config.rasi"

rows=$(awk '
    function xmlesc(s) {
        gsub(/&/, "\\&amp;", s)
        gsub(/</, "\\&lt;", s)
        return s
    }

    # Reset state when starting the second file
    FNR == 1 && NR != 1 { current = ""; last = "" }

    # Section marker
    /^#[[:space:]]*===[[:space:]]+.+[[:space:]]+===[[:space:]]*$/ {
        s = $0
        sub(/^#[[:space:]]*===[[:space:]]+/, "", s)
        sub(/[[:space:]]+===[[:space:]]*$/, "", s)
        if (!(s in seen)) { order[++n] = s; seen[s] = 1 }
        current = s
        last = ""
        next
    }

    # keybindings.txt
    FNR == NR {
        if ($0 !~ /^#/ && $0 !~ /^[[:space:]]*$/) {
            i = index($0, "|")
            if (i > 0 && current != "") {
                key  = substr($0, 1, i - 1)
                desc = substr($0, i + 1)
                gsub(/[[:space:]]+$/, "", key)
                gsub(/^[[:space:]]+/, "", desc)
                if (key != "" && desc != "") {
                    cnt[current]++
                    rkey[current, cnt[current]] = key
                    rdsc[current, cnt[current]] = desc
                }
            }
        }
        next
    }

    END {
        for (i = 1; i <= n; i++) {
            name = order[i]
            if (cnt[name] == 0) continue
            printf "<span foreground=\"#ff8f40\">── %s ──</span>\n", xmlesc(name)
            for (j = 1; j <= cnt[name]; j++) {
                
                # Pad the key string to 35 characters first so Pango tags do not break alignment
                key_padded = sprintf("%-35s", rkey[name, j])
                
                # Escape the XML characters
                key_escaped = xmlesc(key_padded)
                
                # Inject grey color span for the word " or "
                # We close the primary blue span, start a grey span, and reopen the blue span
                gsub(/ or /, "</span> <span foreground=\"#565f89\">or</span> <span foreground=\"#78a9ff\">", key_escaped)
                
                # Print the final assembled string
                printf "<span foreground=\"#78a9ff\">%s</span>  %s\n", key_escaped, xmlesc(rdsc[name, j])
            }
        }
    }
' "$KEYSTXT")

echo "$rows" | rofi -dmenu -markup-rows -i -p "Keybindings" -l 20 \
    -line-padding 4 -hide-scrollbar -theme "$ROFI_THEME" \
    -theme-str "window {width: 800; border: 3px; border-color: #24283b;}"
