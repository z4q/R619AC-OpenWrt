#!/bin/sh
set -e -x
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
curl --retry 5 -L "https://downloads.openwrt.org/releases/$(printf "%s" "$REPO_BRANCH" | cut -c 2-)/targets/ipq40xx/generic/config.buildinfo" > .config
sed -e '/^CONFIG_TARGET_DEVICE_/d' -e '/CONFIG_TARGET_ALL_PROFILES=y/d' -i .config
cat "$GITHUB_WORKSPACE/additional_config.txt" >> .config

chmod +x "$GITHUB_WORKSPACE/checkpatch.sh"
"$GITHUB_WORKSPACE/checkpatch.sh"
chmod +x "$GITHUB_WORKSPACE/patch.sh"
"$GITHUB_WORKSPACE/patch.sh"