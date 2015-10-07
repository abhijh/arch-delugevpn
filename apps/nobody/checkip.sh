#!/bin/bash

echo "[info] checking VPN tunnel local ip is valid..."

# create function to check tunnel local ip is valid
check_valid_ip() {

	IP_ADDRESS="$1"

	# check if ip address looks valid
	if [[ $IP_ADDRESS =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		echo "[info] tun0 interface ip address format correct"
	else
		echo "[warn] tun0 interface ip address format incorrect"; return 1
	fi

	# check that interface is up
	ifconfig | grep tun0 | grep -Eq 'UP'

	if [ $? -eq 0 ]; then
		echo "[info] tun0 interface UP"
	else
		echo "[warn] tun0 interface not UP"; return 1
	fi
	
	return 0
}

# loop and wait until adapter tun0 local ip is valid
LOCAL_IP=""
while ! check_valid_ip "$LOCAL_IP"
do
	sleep 0.1
	LOCAL_IP=`ifconfig tun0 2>/dev/null | grep 'inet' | grep -P -o -m 1 '(?<=inet\s)[^\s]+'`
done