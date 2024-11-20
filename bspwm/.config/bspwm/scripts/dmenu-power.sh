#!/bin/sh

    
case "$(echo -e "Shutdown\nRestart\nLogout\nSuspend\nLock" | dmenu \
    -nb "${COLOR_BACKGROUND:-#1e1e2e}" \
    -nf "${COLOR_DEFAULT:-#cdd6f4}" \
    -sf "${COLOR_HIGHLIGHT:-#1e1e2e}" \
    -sb "#89b4fa" \
    -h 32 -i -p \
    "Power:")" in
        Shutdown) exec systemctl poweroff;;
        Restart) exec systemctl reboot;;
        Logout) bspc quit;;
        Suspend) exec systemctl suspend;;
        Lock) exec systemctl --user start lock.target;;
esac
