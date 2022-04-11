rm -rf ./tmp && rm -rf .config
git pull
./scripts/feeds update -a && ./scripts/feeds install -a
wget https://raw.githubusercontent.com/ozdroid/build/main/1config -O .config
make defconfig
make -j8 download
make -j$(($(nproc) + 1)) V=s
time=$(date "+%Y%m%d-%H%M%S")
echo "------------------------------------------------------------- Uploading File -------------------------------------------------------------------------"
sshpass -p "......" scp -r ./bin taco@192.168.2.249:/mnt/usb/lede/${time}
