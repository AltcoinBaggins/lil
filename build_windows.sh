#!/bin/bash
echo -e "\033[0;32mHow many CPU cores do you want to be used in compiling process? (Default is 1. Press enter for default.)\033[0m"
read -e CPU_CORES
if [ -z "$CPU_CORES" ]
then
	CPU_CORES=1
fi

# Upgrade the system and install required dependencies
	sudo apt update
	sudo apt install git zip unzip build-essential libtool bsdmainutils autotools-dev autoconf pkg-config automake python3 curl g++-mingw-w64-x86-64 libqt5svg5-dev -y
	echo "1" | sudo update-alternatives --config x86_64-w64-mingw32-g++

# Clone code from official Github repository
	rm -rf lapislazuli
	git clone https://github.com/lapislazulicoin/lilli

# Entering directory
	cd lapislazuli

# Compile dependencies
	cd depends
	make -j$(echo $CPU_CORES) HOST=x86_64-w64-mingw32 
	cd ..

# Compile
	./autogen.sh
	./configure --prefix=$(pwd)/depends/x86_64-w64-mingw32 --disable-debug --disable-tests --disable-bench --disable-online-rust CFLAGS="-O3" CXXFLAGS="-O3"
	make -j$(echo $CPU_CORES) HOST=x86_64-w64-mingw32
	cd ..

# Create zip file of binaries
	cp lapislazuli/src/lapislazulid.exe lapislazuli/src/lapislazuli-cli.exe lapislazuli/src/lapislazuli-tx.exe lapislazuli/src/qt/lapislazuli-qt.exe .
	zip LiLLi-Windows.zip lapislazulid.exe lapislazuli-cli.exe lapislazuli-tx.exe lapislazuli-qt.exe
	rm -f lapislazulid.exe lapislazuli-cli.exe lapislazuli-tx.exe lapislazuli-qt.exe
