#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default


#kenzok8
##some clean
rm ~/kenzok8/openwrt-packages/ -rf
rm ~/lede/feeds/luci/themes/luci-theme-atmaterial luci-theme-opentomcat luci-theme-opentomato -rf
rm ~/lede/package/openwrt-packages/* -rf

##git
cd ~/kenzok8
git clone https://github.com/kenzok8/openwrt-packages.git

##kenzok8-passwall
#rm ~/lede/package/small -rf
git clone https://github.com/kenzok8/small.git ~/lede/package/openwrt-packages/small
cp ~/kenzok8/openwrt-packages/luci-app-passwall/ ~/lede/package/openwrt-packages/ -rf

##kenzok8-ADhome
cp ~/kenzok8/openwrt-packages/luci-app-adguardhome ~/lede/package/openwrt-packages/ -rf
cp ~/kenzok8/openwrt-packages/adguardhome ~/lede/package/openwrt-packages/ -rf
cp ~/kenzok8/openwrt-packages/luci-app-advancedsetting ~/lede/package/openwrt-packages/ -rf

##kenzok8-theme
cp ~/kenzok8/openwrt-packages/luci-theme-* ~/lede/feeds/luci/themes/ -rf


##kenzok8-smartdns
#cp ~/kenzok8/openwrt-packages/luci-app-smartdns/  ~/lede/package/openwrt-packages/ -rf
#cp ~/kenzok8/openwrt-packages/smartdns/ ~/lede/package/openwrt-packages/ -rf
#git clone https://github.com/jikkyfu/smartdns.git ~/lede/package/openwrt-packages/smartdns
#cd ~/lede/package/openwrt-packages/smartdns

#smartdns
cd ~/lede

LUCIBRANCH="lede" # lede 分支
# LUCIBRANCH="master" # openwrt 分支

WORKINGDIR="`pwd`/package/openwrt-packages/luci-app-smartdns"

mkdir $WORKINGDIR -p
rm $WORKINGDIR/* -fr
wget https://github.com/pymumu/luci-app-smartdns/archive/${LUCIBRANCH}.zip -O $WORKINGDIR/${LUCIBRANCH}.zip
unzip $WORKINGDIR/${LUCIBRANCH}.zip -d $WORKINGDIR
mv $WORKINGDIR/luci-app-smartdns-${LUCIBRANCH}/* $WORKINGDIR/
rmdir $WORKINGDIR/luci-app-smartdns-${LUCIBRANCH}
rm $WORKINGDIR/${LUCIBRANCH}.zip
rm ~/lede/package/openwrt-packages/smartdns -rf
git clone https://github.com/jikkyfu/smartdns.git ~/lede/package/openwrt-packages/smartdns
cd ~/lede/package/openwrt-packages/smartdns
bash update.sh



#siropboy
rm ~/siropboy -rf
git clone https://github.com/siropboy/mypackages.git  ~/siropboy/
cp ~/siropboy/luci-app-koolproxyR/ ~/lede/package/openwrt-packages/ -rf

#git clone https://github.com/jerrykuku/node-request.git ~/lede/package/openwrt-packages/node-request
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git ~/lede/package/openwrt-packages/luci-app-jd-dailybonus

git clone https://github.com/tty228/luci-app-serverchan.git ~/lede/package/openwrt-packages/luci-app-serverchan


# remake
cp ~/zzz-default-settings.bak ~/lede/package/lean/default-settings/files/zzz-default-settings -rf
cp ~/config_generate.bak ~/lede/package/base-files/files/bin/config_generate  -rf
cd ~/lede
make clean
git pull
~/version.sh
~/ip.sh

./scripts/feeds update -a && ./scripts/feeds install -a

make defconfig

