#!/bin/bash

# ubuntu update script--A simple script to update the system

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}>>> Update Script <<< ${NC}"

MY_NON_ROOT_USER=$(id -nu 1000)

# Check user is root
if [ $(id -u) -ne 0 ]; then
  echo -e "Permission denied. You must run this command as sudo"
  exit 1
fi

# A custom log file
LOG_FILE=/home/${MY_NON_ROOT_USER}/update.log

# Functions
print_status () {
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ OK ]${NC}"
  else 
    echo -e "${RED}[ FAIL ]${NC}"
  fi
}

echo ">>> NEW ENTRY" >> $LOG_FILE
date >> $LOG_FILE
echo "· running script"

echo "·· updating sources information..."
apt update &>> $LOG_FILE
print_status

echo "-----------------------" >> $LOG_FILE

echo "·· upgrading packages..."
apt upgrade -y &>> $LOG_FILE
print_status

echo "-----------------------" >> $LOG_FILE

echo "·· removing unnecessary packages..."
apt autoremove -y &>> $LOG_FILE
print_status

echo -e "${BLUE}Done!"

exit
