#!/bin/bash

$1 2>/dev/null
$2 2>/dev/null

if [[ ! -n $1 ]];
then 
    echo -e "\nPlease insert the network segment, example: (./pdiscover.sh 192.168.0)"
	echo ""
	exit
fi

if [[ ! -n $2 ]];
then 
    echo -e "\nPlease insert the maximum port to scan, example: (./pdiscover.sh 192.168.0 15000)"
	echo ""
	exit
fi

echo ""
echo "============================="
echo " ╔═╗╔╦╗╦╔═╗╔═╗╔═╗╦  ╦╔═╗╦═╗ "
echo " ╠═╝ ║║║╚═╗║  ║ ║╚╗╔╝║╣ ╠╦╝ "
echo " ╩  ═╩╝╩╚═╝╚═╝╚═╝ ╚╝ ╚═╝╩╚═ "
echo "============================="
echo "@microjoan"

subred=$1

echo -e "\n - Scanning segment $subred.0:"

for i in $(seq 1 254); do 

	timeout 1 bash -c "ping -c 1 $subred.$i" &>/dev/null && echo -e "\t[+] Host up: $subred.$i " &
	
	ip="$subred.$i"

	#comprobamos de nuevo si la máquina está activa
	ping -c 1 -w 1 $ip >/dev/null

	if [[ $? == 0 ]] #si el codigo de salida del ultimo comando es 0 significa que el equipo está activo
	then
		
		for port in $(seq 1 $2); do
			timeout 1 bash -c "echo '' > /dev/tcp/$ip/$port" 2>/dev/null && echo -e "\t\t $port/tcp open" &
		done; wait
		echo -e "\n"
	fi
done; wait

echo ""
echo "Done!"
exit

