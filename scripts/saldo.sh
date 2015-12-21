#!/usr/bin/env bash

USER=32

for __ in $(seq 1 3);
do
	echo -n "POS PIN: "
	stty -echo
	read pin
	stty echo
	echo ""
	saldo=$(curl -s "http://dev.automatis.nl/pos/api/?action=get_user_balance&pin=$pin&user=$USER")
	if [[ $saldo == \"* || $saldo == "" ]];
	then 
		echo "Invalid PIN"
	else 
		printf "Saldo: €%s\n" $saldo 
		break 
	fi 
done
