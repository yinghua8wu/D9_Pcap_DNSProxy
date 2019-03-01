#!/bin/bash

sudo apt-get install gcc cmake libpcap-dev libevent-dev openssl libssl-dev dnsutils git -y

wget https://github.com/jedisct1/libsodium/releases/download/1.0.17/libsodium-1.0.17.tar.gz
tar -xvzf libsodium-1.0.17.tar.gz
cd libsodium-1.0.17
sudo ./configure
sudo make && make check
sudo make install
cd ..

wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
tar -xvzf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
sudo ./configure
sudo make && make install
cd ..

sudo git clone https://github.com/5high/Pcap_DNSProxy.git
cd Pcap_DNSProxy/Source/Auxiliary/Scripts 
sudo chmod 755 CMake_Build.sh
sudo ./CMake_Build.sh
cd ../../Release/
sudo cp -f Pcap_DNSProxy /usr/bin/
sudo chmod +x /usr/bin/Pcap_DNSProxy
cd ../Auxiliary/ExampleConfig/
sudo mkdir /etc/Pcap_DNSProxy
sudo cp -f Config.conf /etc/Pcap_DNSProxy/
sudo cp -f WhiteList.txt /etc/Pcap_DNSProxy/
sudo cp -f Pcap_DNSProxy.service /etc/systems/system/
sudo systemctl daemon-reload
sudo systemctl enable Pcap_DNSProxy
sudo systemctl start Pcap_DNSProxy
