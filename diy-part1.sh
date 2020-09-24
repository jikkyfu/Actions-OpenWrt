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

=============================================
DIR="$(dirname "$PWD")"
#mkdir $DIR -p


#kenzok8
##some clean
rm $DIR/kenzok8/ -rf
rm $DIR/openwrt/feeds/luci/themes/luci-theme-atmaterial luci-theme-opentomcat luci-theme-opentomato -rf
rm $DIR/openwrt/package/openwrt-packages/* -rf

##git
mkdir $DIR/kenzok8 -p
cd $DIR/kenzok8
git clone https://github.com/kenzok8/openwrt-packages.git

##kenzok8-passwall
#rm $DIR/openwrt/package/small -rf
git clone https://github.com/kenzok8/small.git $DIR/openwrt/package/openwrt-packages/small
cp $DIR/kenzok8/openwrt-packages/luci-app-passwall/ $DIR/openwrt/package/openwrt-packages/ -rf

##kenzok8-ADhome
cp $DIR/kenzok8/openwrt-packages/luci-app-adguardhome $DIR/openwrt/package/openwrt-packages/ -rf
cp $DIR/kenzok8/openwrt-packages/adguardhome $DIR/openwrt/package/openwrt-packages/ -rf
cp $DIR/kenzok8/openwrt-packages/luci-app-advancedsetting $DIR/openwrt/package/openwrt-packages/ -rf

##kenzok8-theme
cp $DIR/kenzok8/openwrt-packages/luci-theme-* $DIR/openwrt/feeds/luci/themes/ -rf


##kenzok8-smartdns
#cp $DIR/kenzok8/openwrt-packages/luci-app-smartdns/  $DIR/openwrt/package/openwrt-packages/ -rf
#cp $DIR/kenzok8/openwrt-packages/smartdns/ $DIR/openwrt/package/openwrt-packages/ -rf
#git clone https://github.com/jikkyfu/smartdns.git $DIR/openwrt/package/openwrt-packages/smartdns
#cd $DIR/openwrt/package/openwrt-packages/smartdns

#smartdns
cd $DIR/openwrt

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
rm $DIR/openwrt/package/openwrt-packages/smartdns -rf
git clone https://github.com/jikkyfu/smartdns.git $DIR/openwrt/package/openwrt-packages/smartdns
cd $DIR/openwrt/package/openwrt-packages/smartdns
bash update.sh



#siropboy
rm $DIR/siropboy -rf
git clone https://github.com/siropboy/mypackages.git  $DIR/siropboy/
cp $DIR/siropboy/luci-app-koolproxyR/ $DIR/openwrt/package/openwrt-packages/ -rf

#git clone https://github.com/jerrykuku/node-request.git $DIR/openwrt/package/openwrt-packages/node-request
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus.git $DIR/openwrt/package/openwrt-packages/luci-app-jd-dailybonus

git clone https://github.com/tty228/luci-app-serverchan.git $DIR/openwrt/package/openwrt-packages/luci-app-serverchan


# remake
cp $DIR/zzz-default-settings.bak $DIR/openwrt/package/lean/default-settings/files/zzz-default-settings -rf
cp $DIR/config_generate.bak $DIR/openwrt/package/base-files/files/bin/config_generate  -rf
cd $DIR/openwrt

#$DIR/version.sh
version=`cat $DIR/openwrt/package/lean/default-settings/files/zzz-default-settings| grep "DISTRIB_REVISION='R"| sed "s/.*DISTRIB_REVISION='R\(.*\)/\1/"| cut -d "'" -f1`
echo $version
sed -i "s/$version/$version (Compiled at $(date "+%b%d,%Y %H:%M"))/g"  $DIR/openwrt/package/lean/default-settings/files/zzz-default-settings

#$DIR/ip.sh
sed -i 's/192.168.1.1/192.168.2.2/g' $DIR/openwrt/package/base-files/files/bin/config_generate
line=`cat $DIR/openwrt/package/base-files/files/bin/config_generate | grep '$netm' -n| cut -d: -f1`
blank='				'
sed -i "N;$line a jikky$blank set network.\$1.dns='119.29.29.29 223.5.5.5'"  $DIR/openwrt/package/base-files/files/bin/config_generate
sed -i "N;$line a jikky$blank set network.\$1.gateway=\'192.168.2.1\'" $DIR/openwrt/package/base-files/files/bin/config_generate
sed -i 's/jikky	/ /g' $DIR/openwrt/package/base-files/files/bin/config_generate
