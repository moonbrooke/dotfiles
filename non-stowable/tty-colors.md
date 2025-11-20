# TTY Colors

### Grub

1. Edit `/etc/default/grub` and append the theme kernel options to `GRUB_CMDLINE_LINUX` (eg. `GRUB_CMDLINE_LINUX="vt.default_red..."`)
2. Run `sudo grub-mkconfig -o /boot/grub/grub.cfg` to regenerate the grub config.
3. Done.

### Tokyo Night

```bash
vt.default_red=26,247,158,224,122,187,115,192,86,247,158,224,122,187,115,169 vt.default_grn=27,118,206,175,162,154,218,202,95,118,206,175,162,154,218,177 vt.default_blu=38,142,106,104,247,247,202,245,137,142,106,104,247,247,202,214
```

### Catppuccin Mocha

```bash
vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166 vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173 vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200
```
