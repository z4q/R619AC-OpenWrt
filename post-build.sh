#!/bin/sh
set -e -x

_version="$(printf "%s" "$REPO_BRANCH" | cut -c 2-)"
_vermagic="$(curl --retry 5 -L "https://downloads.openwrt.org/releases/${_version}/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic.manifest" | sed -e '/^kernel/!d' -e 's/^.*-\([^-]*\)$/\1/g' | head -n 1)"

OLD_CWD="$(pwd)"

[ "$(find build_dir/ -name .vermagic -exec cat {} \;)" = "$_vermagic" ] && \
mkdir ~/imb && \
tar -xJf bin/targets/ipq40xx/generic/openwrt-imagebuilder-${_version}-ipq40xx-generic.Linux-x86_64.tar.xz -C ~/imb && \
cd ~/imb/* && \
make image PROFILE='p2w_r619ac' && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin ../openwrt-${_version}-minimal-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi ../openwrt-${_version}-minimal-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-minimal-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin && \
make clean && \
\
make image PROFILE='p2w_r619ac-128m' && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi ../openwrt-${_version}-minimal-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-minimal-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin && \
make clean && \
\
make image PROFILE='p2w_r619ac-128m' PACKAGES='libopenssl-conf' && \
make clean && \
\
mkdir -p files/etc/opkg/ files/etc/ssl/ && \
cp build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/root.orig-ipq40xx/etc/opkg/distfeeds.conf files/etc/opkg/ && \
cp build_dir/target-arm_cortex-a7+neon-vfpv4_musl_eabi/root.orig-ipq40xx/etc/ssl/openssl.cnf files/etc/ssl/ && \
sed -i 's|http://downloads.openwrt.org|https://mirrors.tuna.tsinghua.edu.cn/openwrt|g' files/etc/opkg/distfeeds.conf && \
sed -i -e 's|#devcrypto=devcrypto|devcrypto=devcrypto|' -e 's|#afalg=afalg|afalg=afalg|' files/etc/ssl/openssl.cnf && \
\
make image PROFILE='p2w_r619ac' PACKAGES='ca-certificates ca-bundle libustream-mbedtls luci-i18n-base-zh-cn luci-theme-material luci-i18n-firewall-zh-cn luci-i18n-opkg-zh-cn luci-mod-admin-full luci-proto-ipv6 luci-i18n-uhttpd-zh-cn' FILES=files/ && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin ../openwrt-${_version}-chn-minimal-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi ../openwrt-${_version}-chn-minimal-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-chn-minimal-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin && \
make clean && \
\
make image PROFILE='p2w_r619ac-128m' PACKAGES='ca-certificates ca-bundle libustream-mbedtls luci-i18n-base-zh-cn luci-theme-material luci-i18n-firewall-zh-cn luci-i18n-opkg-zh-cn luci-mod-admin-full luci-proto-ipv6 luci-i18n-uhttpd-zh-cn' FILES=files/ && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi ../openwrt-${_version}-chn-minimal-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-chn-minimal-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin && \
make clean && \
\
make image PROFILE='p2w_r619ac' PACKAGES='ca-certificates ca-bundle libustream-mbedtls luci-i18n-base-zh-cn luci-theme-material luci-i18n-firewall-zh-cn luci-i18n-opkg-zh-cn luci-mod-admin-full luci-proto-ipv6 luci-i18n-uhttpd-zh-cn luci-proto-ppp rpcd-mod-rrdns' FILES=files/ && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin ../openwrt-${_version}-chn-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi ../openwrt-${_version}-chn-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-chn-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin && \
make clean && \
\
make image PROFILE='p2w_r619ac-128m' PACKAGES='ca-certificates ca-bundle libustream-mbedtls luci-i18n-base-zh-cn luci-theme-material luci-i18n-firewall-zh-cn luci-i18n-opkg-zh-cn luci-mod-admin-full luci-proto-ipv6 luci-i18n-uhttpd-zh-cn luci-proto-ppp rpcd-mod-rrdns' FILES=files/ && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi ../openwrt-${_version}-chn-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-chn-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin && \
make clean && \
\
make image PROFILE='p2w_r619ac' PACKAGES='block-mount -dnsmasq dnsmasq-full -wpad-basic wpad-openssl libopenssl-devcrypto libopenssl-afalg_sync ca-certificates ca-bundle luci-theme-material luci-mod-admin-full rpcd-mod-rrdns luci-proto-ipv6 luci-proto-ppp luci-proto-3g luci-proto-hnet luci-proto-ipip luci-proto-ncm luci-proto-openconnect luci-proto-pppossh luci-proto-qmi luci-proto-relay luci-proto-vpnc luci-proto-wireguard luci-i18n-adblock-zh-cn luci-i18n-advanced-reboot-zh-cn luci-i18n-ahcp-zh-cn luci-i18n-aria2-zh-cn luci-i18n-attendedsysupgrade-zh-cn luci-i18n-banip-zh-cn luci-i18n-base-zh-cn luci-i18n-bcp38-zh-cn luci-i18n-bmx7-zh-cn luci-i18n-clamav-zh-cn luci-i18n-commands-zh-cn luci-i18n-cshark-zh-cn luci-i18n-dcwapd-zh-cn luci-i18n-ddns-zh-cn luci-i18n-diag-core-zh-cn luci-i18n-dnscrypt-proxy-zh-cn luci-i18n-dump1090-zh-cn luci-i18n-dynapoint-zh-cn luci-i18n-firewall-zh-cn luci-i18n-fwknopd-zh-cn luci-i18n-hd-idle-zh-cn luci-i18n-https-dns-proxy-zh-cn luci-i18n-ksmbd-zh-cn luci-i18n-lxc-zh-cn luci-i18n-minidlna-zh-cn luci-i18n-mjpg-streamer-zh-cn luci-i18n-mwan3-zh-cn luci-i18n-nft-qos-zh-cn luci-i18n-nlbwmon-zh-cn luci-i18n-ntpc-zh-cn luci-i18n-nut-zh-cn luci-i18n-ocserv-zh-cn luci-i18n-olsr-zh-cn luci-i18n-olsr-services-zh-cn luci-i18n-olsr-viz-zh-cn luci-i18n-openvpn-zh-cn luci-i18n-opkg-zh-cn luci-i18n-p910nd-zh-cn luci-i18n-pagekitec-zh-cn luci-i18n-polipo-zh-cn luci-i18n-privoxy-zh-cn luci-i18n-qos-zh-cn luci-i18n-radicale-zh-cn luci-i18n-radicale2-zh-cn luci-i18n-rp-pppoe-server-zh-cn luci-i18n-samba4-zh-cn luci-i18n-shadowsocks-libev-zh-cn luci-i18n-shairplay-zh-cn luci-i18n-simple-adblock-zh-cn luci-i18n-splash-zh-cn luci-i18n-squid-zh-cn luci-i18n-statistics-zh-cn luci-i18n-tinyproxy-zh-cn luci-i18n-transmission-zh-cn luci-i18n-travelmate-zh-cn luci-i18n-ttyd-zh-cn luci-i18n-udpxy-zh-cn luci-i18n-uhttpd-zh-cn luci-i18n-unbound-zh-cn luci-i18n-upnp-zh-cn luci-i18n-vnstat-zh-cn luci-i18n-watchcat-zh-cn luci-i18n-wifischedule-zh-cn luci-i18n-wireguard-zh-cn luci-i18n-wol-zh-cn luci-i18n-vpnbypass-zh-cn' FILES=files/ && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin ../openwrt-${_version}-full-vpnbypass-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi ../openwrt-${_version}-full-vpnbypass-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-full-vpnbypass-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin && \
make clean && \
\
make image PROFILE='p2w_r619ac-128m' PACKAGES='block-mount -dnsmasq dnsmasq-full -wpad-basic wpad-openssl libopenssl-devcrypto libopenssl-afalg_sync ca-certificates ca-bundle luci-theme-material luci-mod-admin-full rpcd-mod-rrdns luci-proto-ipv6 luci-proto-ppp luci-proto-3g luci-proto-hnet luci-proto-ipip luci-proto-ncm luci-proto-openconnect luci-proto-pppossh luci-proto-qmi luci-proto-relay luci-proto-vpnc luci-proto-wireguard luci-i18n-adblock-zh-cn luci-i18n-advanced-reboot-zh-cn luci-i18n-ahcp-zh-cn luci-i18n-aria2-zh-cn luci-i18n-attendedsysupgrade-zh-cn luci-i18n-banip-zh-cn luci-i18n-base-zh-cn luci-i18n-bcp38-zh-cn luci-i18n-bmx7-zh-cn luci-i18n-clamav-zh-cn luci-i18n-commands-zh-cn luci-i18n-cshark-zh-cn luci-i18n-dcwapd-zh-cn luci-i18n-ddns-zh-cn luci-i18n-diag-core-zh-cn luci-i18n-dnscrypt-proxy-zh-cn luci-i18n-dump1090-zh-cn luci-i18n-dynapoint-zh-cn luci-i18n-firewall-zh-cn luci-i18n-fwknopd-zh-cn luci-i18n-hd-idle-zh-cn luci-i18n-https-dns-proxy-zh-cn luci-i18n-ksmbd-zh-cn luci-i18n-lxc-zh-cn luci-i18n-minidlna-zh-cn luci-i18n-mjpg-streamer-zh-cn luci-i18n-mwan3-zh-cn luci-i18n-nft-qos-zh-cn luci-i18n-nlbwmon-zh-cn luci-i18n-ntpc-zh-cn luci-i18n-nut-zh-cn luci-i18n-ocserv-zh-cn luci-i18n-olsr-zh-cn luci-i18n-olsr-services-zh-cn luci-i18n-olsr-viz-zh-cn luci-i18n-openvpn-zh-cn luci-i18n-opkg-zh-cn luci-i18n-p910nd-zh-cn luci-i18n-pagekitec-zh-cn luci-i18n-polipo-zh-cn luci-i18n-privoxy-zh-cn luci-i18n-qos-zh-cn luci-i18n-radicale-zh-cn luci-i18n-radicale2-zh-cn luci-i18n-rp-pppoe-server-zh-cn luci-i18n-samba4-zh-cn luci-i18n-shadowsocks-libev-zh-cn luci-i18n-shairplay-zh-cn luci-i18n-simple-adblock-zh-cn luci-i18n-splash-zh-cn luci-i18n-squid-zh-cn luci-i18n-statistics-zh-cn luci-i18n-tinyproxy-zh-cn luci-i18n-transmission-zh-cn luci-i18n-travelmate-zh-cn luci-i18n-ttyd-zh-cn luci-i18n-udpxy-zh-cn luci-i18n-uhttpd-zh-cn luci-i18n-unbound-zh-cn luci-i18n-upnp-zh-cn luci-i18n-vnstat-zh-cn luci-i18n-watchcat-zh-cn luci-i18n-wifischedule-zh-cn luci-i18n-wireguard-zh-cn luci-i18n-wol-zh-cn luci-i18n-vpnbypass-zh-cn' FILES=files/ && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi ../openwrt-${_version}-full-vpnbypass-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-full-vpnbypass-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin && \
make clean && \
\
make image PROFILE='p2w_r619ac' PACKAGES='block-mount -dnsmasq dnsmasq-full -wpad-basic wpad-openssl libopenssl-devcrypto libopenssl-afalg_sync ca-certificates ca-bundle luci-theme-material luci-mod-admin-full rpcd-mod-rrdns luci-proto-ipv6 luci-proto-ppp luci-proto-3g luci-proto-hnet luci-proto-ipip luci-proto-ncm luci-proto-openconnect luci-proto-pppossh luci-proto-qmi luci-proto-relay luci-proto-vpnc luci-proto-wireguard luci-i18n-adblock-zh-cn luci-i18n-advanced-reboot-zh-cn luci-i18n-ahcp-zh-cn luci-i18n-aria2-zh-cn luci-i18n-attendedsysupgrade-zh-cn luci-i18n-banip-zh-cn luci-i18n-base-zh-cn luci-i18n-bcp38-zh-cn luci-i18n-bmx7-zh-cn luci-i18n-clamav-zh-cn luci-i18n-commands-zh-cn luci-i18n-cshark-zh-cn luci-i18n-dcwapd-zh-cn luci-i18n-ddns-zh-cn luci-i18n-diag-core-zh-cn luci-i18n-dnscrypt-proxy-zh-cn luci-i18n-dump1090-zh-cn luci-i18n-dynapoint-zh-cn luci-i18n-firewall-zh-cn luci-i18n-fwknopd-zh-cn luci-i18n-hd-idle-zh-cn luci-i18n-https-dns-proxy-zh-cn luci-i18n-ksmbd-zh-cn luci-i18n-lxc-zh-cn luci-i18n-minidlna-zh-cn luci-i18n-mjpg-streamer-zh-cn luci-i18n-mwan3-zh-cn luci-i18n-nft-qos-zh-cn luci-i18n-nlbwmon-zh-cn luci-i18n-ntpc-zh-cn luci-i18n-nut-zh-cn luci-i18n-ocserv-zh-cn luci-i18n-olsr-zh-cn luci-i18n-olsr-services-zh-cn luci-i18n-olsr-viz-zh-cn luci-i18n-openvpn-zh-cn luci-i18n-opkg-zh-cn luci-i18n-p910nd-zh-cn luci-i18n-pagekitec-zh-cn luci-i18n-polipo-zh-cn luci-i18n-privoxy-zh-cn luci-i18n-qos-zh-cn luci-i18n-radicale-zh-cn luci-i18n-radicale2-zh-cn luci-i18n-rp-pppoe-server-zh-cn luci-i18n-samba4-zh-cn luci-i18n-shadowsocks-libev-zh-cn luci-i18n-shairplay-zh-cn luci-i18n-simple-adblock-zh-cn luci-i18n-splash-zh-cn luci-i18n-squid-zh-cn luci-i18n-statistics-zh-cn luci-i18n-tinyproxy-zh-cn luci-i18n-transmission-zh-cn luci-i18n-travelmate-zh-cn luci-i18n-ttyd-zh-cn luci-i18n-udpxy-zh-cn luci-i18n-uhttpd-zh-cn luci-i18n-unbound-zh-cn luci-i18n-upnp-zh-cn luci-i18n-vnstat-zh-cn luci-i18n-watchcat-zh-cn luci-i18n-wifischedule-zh-cn luci-i18n-wireguard-zh-cn luci-i18n-wol-zh-cn luci-i18n-vpn-policy-routing-zh-cn' FILES=files/ && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin ../openwrt-${_version}-full-vpnpolicyrouting-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi ../openwrt-${_version}-full-vpnpolicyrouting-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-full-vpnpolicyrouting-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin && \
make clean && \
\
make image PROFILE='p2w_r619ac-128m' PACKAGES='block-mount -dnsmasq dnsmasq-full -wpad-basic wpad-openssl libopenssl-devcrypto libopenssl-afalg_sync ca-certificates ca-bundle luci-theme-material luci-mod-admin-full rpcd-mod-rrdns luci-proto-ipv6 luci-proto-ppp luci-proto-3g luci-proto-hnet luci-proto-ipip luci-proto-ncm luci-proto-openconnect luci-proto-pppossh luci-proto-qmi luci-proto-relay luci-proto-vpnc luci-proto-wireguard luci-i18n-adblock-zh-cn luci-i18n-advanced-reboot-zh-cn luci-i18n-ahcp-zh-cn luci-i18n-aria2-zh-cn luci-i18n-attendedsysupgrade-zh-cn luci-i18n-banip-zh-cn luci-i18n-base-zh-cn luci-i18n-bcp38-zh-cn luci-i18n-bmx7-zh-cn luci-i18n-clamav-zh-cn luci-i18n-commands-zh-cn luci-i18n-cshark-zh-cn luci-i18n-dcwapd-zh-cn luci-i18n-ddns-zh-cn luci-i18n-diag-core-zh-cn luci-i18n-dnscrypt-proxy-zh-cn luci-i18n-dump1090-zh-cn luci-i18n-dynapoint-zh-cn luci-i18n-firewall-zh-cn luci-i18n-fwknopd-zh-cn luci-i18n-hd-idle-zh-cn luci-i18n-https-dns-proxy-zh-cn luci-i18n-ksmbd-zh-cn luci-i18n-lxc-zh-cn luci-i18n-minidlna-zh-cn luci-i18n-mjpg-streamer-zh-cn luci-i18n-mwan3-zh-cn luci-i18n-nft-qos-zh-cn luci-i18n-nlbwmon-zh-cn luci-i18n-ntpc-zh-cn luci-i18n-nut-zh-cn luci-i18n-ocserv-zh-cn luci-i18n-olsr-zh-cn luci-i18n-olsr-services-zh-cn luci-i18n-olsr-viz-zh-cn luci-i18n-openvpn-zh-cn luci-i18n-opkg-zh-cn luci-i18n-p910nd-zh-cn luci-i18n-pagekitec-zh-cn luci-i18n-polipo-zh-cn luci-i18n-privoxy-zh-cn luci-i18n-qos-zh-cn luci-i18n-radicale-zh-cn luci-i18n-radicale2-zh-cn luci-i18n-rp-pppoe-server-zh-cn luci-i18n-samba4-zh-cn luci-i18n-shadowsocks-libev-zh-cn luci-i18n-shairplay-zh-cn luci-i18n-simple-adblock-zh-cn luci-i18n-splash-zh-cn luci-i18n-squid-zh-cn luci-i18n-statistics-zh-cn luci-i18n-tinyproxy-zh-cn luci-i18n-transmission-zh-cn luci-i18n-travelmate-zh-cn luci-i18n-ttyd-zh-cn luci-i18n-udpxy-zh-cn luci-i18n-uhttpd-zh-cn luci-i18n-unbound-zh-cn luci-i18n-upnp-zh-cn luci-i18n-vnstat-zh-cn luci-i18n-watchcat-zh-cn luci-i18n-wifischedule-zh-cn luci-i18n-wireguard-zh-cn luci-i18n-wol-zh-cn luci-i18n-vpn-policy-routing-zh-cn' FILES=files/ && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi ../openwrt-${_version}-full-vpnpolicyrouting-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-full-vpnpolicyrouting-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin && \
make clean && \
\
make image PROFILE='p2w_r619ac' PACKAGES='ca-certificates ca-bundle libustream-openssl luci-i18n-base-zh-cn luci-theme-material luci-i18n-firewall-zh-cn luci-i18n-opkg-zh-cn luci-mod-admin-full luci-proto-ipv6 luci-i18n-uhttpd-zh-cn luci-i18n-commands-zh-cn luci-i18n-ttyd-zh-cn luci-proto-ppp rpcd-mod-rrdns luci-proto-hnet -dnsmasq dnsmasq-full block-mount -wpad-basic wpad-openssl libopenssl-devcrypto libopenssl-afalg_sync' FILES=files/ && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin ../openwrt-${_version}-chn-hwenc-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.bin && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi ../openwrt-${_version}-chn-hwenc-ipq40xx-generic-p2w_r619ac-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-chn-hwenc-ipq40xx-generic-p2w_r619ac-squashfs-nand-sysupgrade.bin && \
make clean && \
\
make image PROFILE='p2w_r619ac-128m' PACKAGES='ca-certificates ca-bundle libustream-openssl luci-i18n-base-zh-cn luci-theme-material luci-i18n-firewall-zh-cn luci-i18n-opkg-zh-cn luci-mod-admin-full luci-proto-ipv6 luci-i18n-uhttpd-zh-cn luci-i18n-commands-zh-cn luci-i18n-ttyd-zh-cn luci-proto-ppp rpcd-mod-rrdns luci-proto-hnet -dnsmasq dnsmasq-full block-mount -wpad-basic wpad-openssl libopenssl-devcrypto libopenssl-afalg_sync' FILES=files/ && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi ../openwrt-${_version}-chn-hwenc-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-factory.ubi && \
mv bin/targets/ipq40xx/generic/openwrt-${_version}-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin ../openwrt-${_version}-chn-hwenc-ipq40xx-generic-p2w_r619ac-128m-squashfs-nand-sysupgrade.bin && \
make clean && \
mv ../*.bin ../*.ubi "$OLD_CWD/bin/targets/ipq40xx/generic/"

cd "$OLD_CWD/bin/targets"/*/*
mv openwrt-imagebuilder-* openwrt-sdk-* ..
rm -rf packages
tar -c * | xz -z -e -9 -T 0 > "../$(grep -i "openwrt-.*-sysupgrade.bin" *sums | head -n 1 | cut -d "*" -f 2 | cut -d - -f 1-5)-firmware.tar.xz"
rm -rf *
xz -d -c ../openwrt-imagebuilder-* | xz -z -e -9 -T 0 > "$(basename ../openwrt-imagebuilder-*)"
xz -d -c ../openwrt-sdk-* | xz -z -e -9 -T 0 > "$(basename ../openwrt-sdk-*)"
mv ../*-firmware.tar.xz .
rm -f ../openwrt-imagebuilder-* ../openwrt-sdk-* *sums
sha256sum * > ../sha256sums
mv ../sha256sums .