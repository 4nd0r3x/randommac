#!/bin/bash
sudo systemctl stop NetworkManager

echo "Current NIC's:"
interfaces=$(ls /sys/class/net)

select interface in $interfaces
do
    if [ -n "$interface" ]; then
        echo "Selected nic: $interface"
        break
    else
        echo "wrong choice try again ?"
    fi
done

new_mac=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')

echo "Old MAC Addr :"
ip link show $interface | awk '/ether/ {print $2}'

sudo ip link set dev $interface down

if [[ $new_mac =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
    sudo ip link set dev $interface address $new_mac
    echo "New MAC Addr: $new_mac"
else
    echo "Invalid MAC address: $new_mac"
fi

sudo ip link set dev $interface up

sudo systemctl start NetworkManager
#4nd0r3x
