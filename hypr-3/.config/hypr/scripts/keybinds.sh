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

    # Section marker (both files)
    /^#[[:space:]]*===[[:space:]]+.+[[:space:]]+===[[:space:]]*$/ {
        s = $0
        sub(/^#[[:space:]]*===[[:space:]]+/, "", s)
        sub(/[[:space:]]+===[[:space:]]*$/, "", s)
        if (!(s in seen)) { order[++n] = s; seen[s] = 1 }
        current = s
        last = ""
        next
    }

    # First file: keybindings.txt (tab-separated key<TAB>desc)
    FNR == NR {
        if ($0 !~ /^#/ && $0 !~ /^[[:space:]]*$/) {
            i = index($0, "\t")
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

    # Second file: sxhkdrc (# desc followed by key line)
    /^#/ { last = substr($0, 3); next }
    /^[A-Za-z]/ && last && current != "" {
        cnt[current]++
        rkey[current, cnt[current]] = $0
        rdsc[current, cnt[current]] = last
        last = ""
        next
    }
    { last = "" }

    END {
        for (i = 1; i <= n; i++) {
            name = order[i]
            if (cnt[name] == 0) continue
            printf "<span size=\"large\" weight=\"bold\" foreground=\"#ff8f40\">── %s ──</span>\n", xmlesc(name)
            for (j = 1; j <= cnt[name]; j++) {
                printf "<span foreground=\"#78a9ff\">%-35s</span>  %s\n", xmlesc(rkey[name, j]), xmlesc(rdsc[name, j])
            }
        }
    }
' "$KEYSTXT")

echo "$rows" | rofi -dmenu -markup-rows -i -p "Keybindings" \
    -line-padding 4 -hide-scrollbar -theme "$ROFI_THEME" \
    -theme-str "window {width: 800;}"

