#!/bin/bash
#lede

cpucore=$nproc
echo "Current PC cup core == $cpucore"


#Clean and re git clone lede
echo "------------------------------------------------------------- Start download Lede -------------------------------------------------------------------------"
rm -rf ./lede
git clone https://github.com/coolsnowwolf/lede
cd ./lede

#update Feed and git clone luci
echo "------------------------------------------------------------- Update -------------------------------------------------------------------------"
  
sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
sed -i '$a src-git small8 https://github.com/kenzok8/small-package' feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a 

echo "------------------------------------------------------------- Update Config -------------------------------------------------------------------------"
rm -rf .config
wget https://raw.githubusercontent.com/ozdroid/build/main/1config -O .config
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
sed -i 's/luci-theme-bootstrap/luci-theme-neobird/g' feeds/luci/collections/luci/Makefile
make menuconfig

#Download
echo "------------------------------------------------------------- Download File -------------------------------------------------------------------------"
make -j8 download
find dl -size -1024c -exec ls -l {} \;
find dl -size -1024c -exec rm -f {} \;

#Compile
echo "------------------------------------------------------------- Start Compile -------------------------------------------------------------------------"
make -j$cpucore V=s

#Upload files
time=$(date "+%Y%m%d-%H%M%S")
echo "------------------------------------------------------------- Uploading File -------------------------------------------------------------------------"
sshpass -p "wszasd" scp -r ./bin taco@192.168.2.249:/mnt/usb/lede/${time}
exit 0
