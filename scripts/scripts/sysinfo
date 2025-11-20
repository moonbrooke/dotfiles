#!/bin/bash

# Colors
BOLD="\e[1m"
RESET="\e[0m"
CYAN="\e[36m"
GREEN="\e[32m"
MAGENTA="\e[35m"

# System Info
USER_HOST="${BOLD}${CYAN}${USER}@${HOSTNAME}${RESET}"
DISTRO=$(source /etc/os-release && echo "$NAME $VERSION")
KERNEL=$(uname -r)
RAM_USED=$(free -h | awk '/^Mem:/ {print $3}')
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
RAM="${RAM_USED} / ${RAM_TOTAL}"

# Output
echo -e "$USER_HOST"
echo -e "${BOLD}${GREEN}OS:       ${RESET}$DISTRO"
echo -e "${BOLD}${GREEN}Kernel:   ${RESET}$KERNEL"
echo -e "${BOLD}${GREEN}RAM:      ${RESET}$RAM"
echo -e ""
