#!/usr/bin/env bash

USER=32

for __ in $(seq 1 3);
do
	echo -n "POS PIN: "
	stty -echo
	read pin
	stty echo
	echo ""
    curl -s "http://dev.automatis.nl/pos/api/?action=buy_products&bijpinnen=0&cart=%7B%22143%22:1%7D&clientKey=kelder_bier_app&forUser=0&method=list&pincode=$pin&user=$USER" | grep "Invalid pin" > /dev/null
	if [[ $? ]];
	then
		echo "Invalid PIN"
	else
        echo "Cheers!"
		break
	fi
done
