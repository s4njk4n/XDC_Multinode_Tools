#!/bin/bash

# Set filename to obtain IP address list for XDC Node VPS's to Update
FILE="ip_addresses"

# Set Colour Vars
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo
echo
echo -e "${GREEN}     #################################################### ${NC}"
echo -e "${GREEN}     #                                                  # ${NC}"
echo -e "${GREEN}     #             AUTOMATIC OS-ONLY UPDATER            # ${NC}"
echo -e "${GREEN}     #              FOR MULTIPLE XDC NODES              # ${NC}"
echo -e "${GREEN}     #                                                  # ${NC}"
echo -e "${GREEN}     # Created by s4njk4n - https://github.com/s4njk4n/ # ${NC}"
echo -e "${GREEN}     #                                                  # ${NC}"
echo -e "${GREEN}     #################################################### ${NC}"
echo
echo
echo

# Set time (in seconds) to wait for your VPS to reboot. You'll have to manually test this. Recommend rounding UP by a minute or 2
echo -e "${RED}How long (in seconds) should be allowed for each VPS to reboot? (Must be LONGER ${NC}"
echo -e "${RED}than the boot time of your SLOWEST booting node). If unsure, set it to ${NC}"
echo -e "${RED}something long like 300(seconds). Setting a longer time isn't harmful, it will ${NC}"
echo -e "${RED}just take longer to finish all the nodes. If the time selected isn't long ${NC}"
echo -e "${RED}enough however, then the update will not succeed. ${NC}"
read WAITTOREBOOT

while IFS= read line
do

   # This section below was neccessary to separate into individual one-line commands and to run TWICE
   # in order for certain VPS providers to work properly
   echo
   echo
   echo -e "${GREEN}Updating VPS OS & Packages - $line ${NC}"
   ssh -n root@$line 'apt update -y'
   ssh -n root@$line 'apt upgrade -y'
   ssh -n root@$line 'apt autoremove -y'
   ssh -n root@$line 'apt clean -y'
   ssh -n root@$line 'apt update -y'
   ssh -n root@$line 'apt upgrade -y'
   ssh -n root@$line 'apt autoremove -y'
   ssh -n root@$line 'apt clean -y'
   echo
   echo

   echo -e "${GREEN}Deactivating XDC Node - $line ${NC}"
   echo
   ssh -n root@$line 'cd ~/XinFin-Node/mainnet && ./docker-down.sh'
   echo
   echo

   echo -e "${GREEN}Rebooting VPS - $line ${NC}"
   ssh -n root@$line 'reboot' > /dev/null 2>&1
   sleep $WAITTOREBOOT
   echo
   echo

   echo -e "${GREEN}Activating XDC Node - $line ${NC}"
   ssh -n root@$line 'cd ~/XinFin-Node/mainnet && ./docker-up.sh'
   echo
   echo

   echo -e "${GREEN}Congratulations! Your XDC VPS OS at $line has now been updated ${NC}"
   echo
   echo -e "${GREEN}--------------------------------------------------------------- ${NC}"
   echo

done < "$FILE"

echo -e "${RED}              ALL XDC VPS OS UPDATES COMPLETED ${NC}"
echo
echo -e "${GREEN}--------------------------------------------------------------- ${NC}"
echo
echo -e "${GREEN}Please visit the XDC Foundation Network Stats page to check ${NC}"
echo -e "${GREEN}your node statuses:"
echo
printf '\e]8;;https://stats.xdc.org\e\\https://stats.xdc.org\e]8;;\e\\\n'
echo -e "${NC}"
echo -e "${GREEN}--------------------------------------------------------------- ${NC}"
