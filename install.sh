#!/bin/bash
#修改国内apt源
echo -e "\033[32m正在修改apt源\033[0m"
sudo echo 'deb http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main contrib non-free rpi' > /etc/apt/sources.list
sudo echo 'deb-src http://mirrors.tuna.tsinghua.edu.cn/raspbian/raspbian/ stretch main contrib non-free rpi' >> /etc/apt/sources.list
sudo echo 'deb http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ stretch main ui' > /etc/apt/sources.list.d/raspi.list
sudo echo 'deb-src http://mirror.tuna.tsinghua.edu.cn/raspberrypi/ stretch main ui' >> /etc/apt/sources.list.d/raspi.list
sudo apt-get update
sudo apt-get -y install gcc cmake openssl libssl-dev dnsutils git flex bison

echo -e "\033[32m正在下载安装libpcap\033[0m"
wget https://github.com/the-tcpdump-group/libpcap/archive/libpcap-1.9.0.tar.gz
tar -xvzf libpcap-1.9.0.tar.gz
cd libpcap-libpcap-1.9.0
sudo ./configure
sudo make && make check
sudo make install
cd ..
sudo rm -rf libpcap-1.9.0.tar.gz
sudo rm -rf libpcap-libpcap-1.9.0

echo -e "\033[32m正在下载安装libsodium\033[0m"
wget https://github.com/jedisct1/libsodium/releases/download/1.0.17/libsodium-1.0.17.tar.gz
tar -xvzf libsodium-1.0.17.tar.gz
cd libsodium-1.0.17
sudo ./configure
sudo make && make check
sudo make install
cd ..
sudo rm -rf libsodium-1.0.17*

echo -e "\033[32m正在下载安装libevent\033[0m"
wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
tar -xvzf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
sudo ./configure
sudo make && make install
cd ..
sudo rm -rf libevent-2.1.8-stable*

echo -e "\033[32m正在下载安装Pcap_DNSProxy\033[0m"
sudo git clone https://github.com/5high/Pcap_DNSProxy.git
cd Pcap_DNSProxy/Source/Auxiliary/Scripts
sudo chmod 755 CMake_Build.sh
sudo ./CMake_Build.sh
cd ../../../../
cd Pcap_DNSProxy/Source/Release
sudo systemctl stop Pcap_DNSProxy
sudo cp -f Pcap_DNSProxy /usr/bin/
sudo chmod +x /usr/bin/Pcap_DNSProxy
cd ../Auxiliary/ExampleConfig/
sudo mkdir /etc/Pcap_DNSProxy
sudo cp -f Config.ini /etc/Pcap_DNSProxy/
sudo cp -f WhiteList.txt /etc/Pcap_DNSProxy/
sudo cp -f Routing.txt /etc/Pcap_DNSProxy/
cd ../Scripts
sudo cp -f Update_Routing.sh /etc/Pcap_DNSProxy/
sudo cp -f Update_WhiteList.sh /etc/Pcap_DNSProxy/
sudo ldconfig

echo -e "\033[32m正在配置开机自动运行\033[0m"
cd ../ExampleConfig/
sudo cp -f Pcap_DNSProxy.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable Pcap_DNSProxy
sudo systemctl start Pcap_DNSProxy
cd ../../../../
sudo rm -rf Pcap_DNSProxy

cd /etc/Pcap_DNSProxy
sudo bash Update_Routing.sh
sudo bash Update_WhiteList.sh
