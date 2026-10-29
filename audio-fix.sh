#!/usr/bin/env bash

# Fix Intel audio on my MSI laptop by forcing the legacy HDA driver (dsp_driver=1).
set -euo pipefail

CONF=/etc/modprobe.d/audio-fix.conf
CONTENT='options snd-intel-dspcfg dsp_driver=1'

# Pick a privilege escalation command.
if [ "$(id -u)" -eq 0 ]; then
    SUDO=()
elif command -v sudo >/dev/null 2>&1; then
    SUDO=(sudo)
else
    echo "error: root privileges required (run as root or install sudo)" >&2
    exit 1
fi

echo "==> Writing $CONF"
printf '%s\n' "$CONTENT" | "${SUDO[@]}" tee "$CONF" >/dev/null

# Rebuild the initramfs with the command for this distro.
if [ -f /etc/arch-release ] || command -v mkinitcpio >/dev/null 2>&1; then
    echo "==> Arch Linux detected: rebuilding initramfs with mkinitcpio"
    "${SUDO[@]}" mkinitcpio -P
elif [ -f /etc/void-release ] || { command -v xbps-install >/dev/null 2>&1 && command -v dracut >/dev/null 2>&1; }; then
    echo "==> Void Linux detected: rebuilding initramfs with dracut"
    "${SUDO[@]}" dracut --force
else
    echo "error: unsupported distribution (expected Arch Linux or Void Linux)" >&2
    exit 1
fi

echo "==> Done. The new audio setting takes effect after a reboot."

read -r -p "Reboot now? [y/N] " answer
case "$answer" in
    [yY] | [yY][eE][sS])
        echo "==> Rebooting..."
        "${SUDO[@]}" reboot
        ;;
    *)
        echo "Reboot skipped. Run 'sudo reboot' when you are ready."
        ;;
esac
