#!/bin/sh
set -e -x

echo '
define Build/qsdk-ipq-factory-nand
	$(TOPDIR)/scripts/mkits-qsdk-ipq-image.sh \
		$@.its ubi $@
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) mkimage -f $@.its $@.new
	@mv $@.new $@
endef

define Build/qsdk-ipq-factory-nor
	$(TOPDIR)/scripts/mkits-qsdk-ipq-image.sh \
		$@.its hlos $(IMAGE_KERNEL) rootfs $(IMAGE_ROOTFS)
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) mkimage -f $@.its $@.new
	@mv $@.new $@
endef' >> include/image-commands.mk

sed -i 's/ALLWIFIBOARDS[ \t]*:=/ALLWIFIBOARDS:= p2w_r619ac /' package/firmware/ipq-wifi/Makefile
sed -i '/$(eval $(call [^,]*,linksys_ea8300,[^)]*))/a$(eval $(call generate-ipq-wifi-package,p2w_r619ac,board-p2w_r619ac.qca4019,P&W R619AC))' package/firmware/ipq-wifi/Makefile

curl --retry 5 -L https://raw.githubusercontent.com/coolsnowwolf/lede/0fa35495ee4b666ab0f675ac96492c06b5fb6e25/package/firmware/ipq-wifi/board-p2w_r619ac.qca4019 > package/firmware/ipq-wifi/board-p2w_r619ac.qca4019  ## From lean
#curl --retry 5 -L https://raw.githubusercontent.com/x-wrt/x-wrt/cb7d766274aaf36863f10386f6730f94b44dbe43/package/firmware/ipq-wifi/board-p2w_r619ac.qca4019 > package/firmware/ipq-wifi/board-p2w_r619ac.qca4019  ## From X-WRT

curl --retry 5 -L https://raw.githubusercontent.com/coolsnowwolf/lede/0fa35495ee4b666ab0f675ac96492c06b5fb6e25/scripts/mkits-qsdk-ipq-image.sh > scripts/mkits-qsdk-ipq-image.sh

sed -i '/\*)/i\p2w,r619ac |\\' target/linux/ipq40xx/base-files/etc/board.d/01_leds  ## x-wrt have not
sed -i '/\*)/i\p2w,r619ac-128m)' target/linux/ipq40xx/base-files/etc/board.d/01_leds  ## x-wrt have not
sed -i '/\*)/i\\tucidef_set_led_wlan "wlan2g" "WLAN2G" "r619ac:blue:wlan2g" "phy0tpt"' target/linux/ipq40xx/base-files/etc/board.d/01_leds  ## x-wrt have not
sed -i '/\*)/i\\tucidef_set_led_wlan "wlan5g" "WLAN5G" "r619ac:blue:wlan5g" "phy1tpt"' target/linux/ipq40xx/base-files/etc/board.d/01_leds  ## x-wrt have not
sed -i '/\*)/i\\t;;' target/linux/ipq40xx/base-files/etc/board.d/01_leds  ## x-wrt have not

sed -i '/asus,rt-ac58u|/a\\tp2w,r619ac|\\' target/linux/ipq40xx/base-files/etc/board.d/02_network
sed -i '/asus,rt-ac58u|/a\\tp2w,r619ac-128m|\\' target/linux/ipq40xx/base-files/etc/board.d/02_network
sed -i '/asus,rt-ac58u)/i\\tp2w,r619ac-128m|\\' target/linux/ipq40xx/base-files/etc/board.d/02_network
sed -i '/asus,rt-ac58u)/i\\tp2w,r619ac)' target/linux/ipq40xx/base-files/etc/board.d/02_network
sed -i '/asus,rt-ac58u)/i\\t\tlan_mac=$(cat /sys/class/net/eth0/address)' target/linux/ipq40xx/base-files/etc/board.d/02_network
sed -i '/asus,rt-ac58u)/i\\t\twan_mac=$(macaddr_add "$lan_mac" 1)' target/linux/ipq40xx/base-files/etc/board.d/02_network
sed -i '/asus,rt-ac58u)/i\\t\tlabel_mac=$lan_mac' target/linux/ipq40xx/base-files/etc/board.d/02_network
sed -i '/asus,rt-ac58u)/i\\t\t;;' target/linux/ipq40xx/base-files/etc/board.d/02_network

sed -i '/"ath10k\/pre-cal-pci-0000:01:00.0.bin")/a\\tfi' target/linux/ipq40xx/base-files/etc/hotplug.d/firmware/11-ath10k-caldata  ## x-wrt have not
sed -i '/"ath10k\/pre-cal-pci-0000:01:00.0.bin")/a\\t\tath10kcal_extract "ART" 36864 12064' target/linux/ipq40xx/base-files/etc/hotplug.d/firmware/11-ath10k-caldata  ## x-wrt have not
sed -i '/"ath10k\/pre-cal-pci-0000:01:00.0.bin")/a\\tif [ "$board" = "p2w,r619ac" ] || [ "$board" = "p2w,r619ac-128m" ] ; then' target/linux/ipq40xx/base-files/etc/hotplug.d/firmware/11-ath10k-caldata  ## x-wrt have not
sed -i '/8dev,jalapeno[ \t]*|/i\\tp2w,r619ac |\\' target/linux/ipq40xx/base-files/etc/hotplug.d/firmware/11-ath10k-caldata
sed -i '/8dev,jalapeno[ \t]*|/i\\tp2w,r619ac-128m |\\' target/linux/ipq40xx/base-files/etc/hotplug.d/firmware/11-ath10k-caldata

sed -i '/8dev,jalapeno[ \t]*|/i\\tp2w,r619ac-128m |\\' target/linux/ipq40xx/base-files/lib/upgrade/platform.sh
sed -i '/8dev,jalapeno[ \t]*|/i\\tp2w,r619ac |\\' target/linux/ipq40xx/base-files/lib/upgrade/platform.sh

curl --retry 5 -L https://raw.githubusercontent.com/coolsnowwolf/lede/0fa35495ee4b666ab0f675ac96492c06b5fb6e25/target/linux/ipq40xx/files-4.14/arch/arm/boot/dts/qcom-ipq4019-r619ac-128m.dts > target/linux/ipq40xx/files-4.14/arch/arm/boot/dts/qcom-ipq4019-r619ac-128m.dts
curl --retry 5 -L https://raw.githubusercontent.com/coolsnowwolf/lede/0fa35495ee4b666ab0f675ac96492c06b5fb6e25/target/linux/ipq40xx/files-4.14/arch/arm/boot/dts/qcom-ipq4019-r619ac.dts > target/linux/ipq40xx/files-4.14/arch/arm/boot/dts/qcom-ipq4019-r619ac.dts
#curl --retry 5 -L https://raw.githubusercontent.com/coolsnowwolf/lede/0fa35495ee4b666ab0f675ac96492c06b5fb6e25/target/linux/ipq40xx/files-4.14/arch/arm/boot/dts/qcom-ipq4019-r619ac.dtsi > target/linux/ipq40xx/files-4.14/arch/arm/boot/dts/qcom-ipq4019-r619ac.dtsi  ## Use lean's dts
#curl --retry 5 -L https://raw.githubusercontent.com/x-wrt/x-wrt/6d51b76b38a723ca84e13910518030ddc2b7c2f6/target/linux/ipq40xx/files-4.19/arch/arm/boot/dts/qcom-ipq4019-r619ac.dtsi > target/linux/ipq40xx/files-4.14/arch/arm/boot/dts/qcom-ipq4019-r619ac.dtsi  ## Use X-WRT's dts
echo '// SPDX-License-Identifier: GPL-2.0-or-later OR MIT

#include "qcom-ipq4019.dtsi"
#include <dt-bindings/gpio/gpio.h>
#include <dt-bindings/input/input.h>
#include <dt-bindings/soc/qcom,tcsr.h>

/ {
	aliases {
		led-boot = &led_sys;
		led-failsafe = &led_sys;
		led-running = &led_sys;
		led-upgrade = &led_sys;
		label-mac-device = &gmac0;
	};

	soc {
		rng@22000 {
			status = "okay";
		};

		mdio@90000 {
			status = "okay";
			pinctrl-0 = <&mdio_pins>;
			pinctrl-names = "default";
		};

		ess-psgmii@98000 {
			status = "okay";
		};

		tcsr@1949000 {
			compatible = "qcom,tcsr";
			reg = <0x1949000 0x100>;
			qcom,wifi_glb_cfg = <TCSR_WIFI_GLB_CFG>;
		};

		tcsr@194b000 {
			compatible = "qcom,tcsr";
			reg = <0x194b000 0x100>;
			qcom,usb-hsphy-mode-select = <TCSR_USB_HSPHY_HOST_MODE>;
		};

		ess_tcsr@1953000 {
			compatible = "qcom,tcsr";
			reg = <0x1953000 0x1000>;
			qcom,ess-interface-select = <TCSR_ESS_PSGMII>;
		};

		tcsr@1957000 {
			compatible = "qcom,tcsr";
			reg = <0x1957000 0x100>;
			qcom,wifi_noc_memtype_m0_m2 = <TCSR_WIFI_NOC_MEMTYPE_M0_M2>;
		};

		usb2@60f8800 {
			status = "okay";
		};

		usb3@8af8800 {
			status = "okay";
		};

		crypto@8e3a000 {
			status = "okay";
		};

		watchdog@b017000 {
			status = "okay";
		};

		ess-switch@c000000 {
			status = "okay";
		};

		edma@c080000 {
			status = "okay";
		};
	};

	leds {
		compatible = "gpio-leds";
		pinctrl-0 = <&led_pins>;
		pinctrl-names = "default";

		led_sys: sys {
			label = "r619ac:blue:sys";
			gpios = <&tlmm 39 GPIO_ACTIVE_HIGH>;
		};

		wlan2g {
			label = "r619ac:blue:wlan2g";
			gpios = <&tlmm 32 GPIO_ACTIVE_HIGH>;
			linux,default-trigger = "phy0tpt";
		};

		wlan5g {
			label = "r619ac:blue:wlan5g";
			gpios = <&tlmm 50 GPIO_ACTIVE_HIGH>;
			linux,default-trigger = "phy1tpt";
		};
	};

	keys {
		compatible = "gpio-keys";

		reset {
			label = "reset";
			gpios = <&tlmm 18 GPIO_ACTIVE_LOW>;
			linux,code = <KEY_RESTART>;
		};
	};
};

&blsp_dma {
	status = "okay";
};

&blsp1_spi1 {
	status = "okay";

	flash@0 {
		reg = <0>;
		compatible = "jedec,spi-nor";
		spi-max-frequency = <24000000>;

		partitions {
			compatible = "fixed-partitions";
			#address-cells = <1>;
			#size-cells = <1>;

			partition@0 {
				label = "SBL1";
				reg = <0x0 0x40000>;
			};

			partition@40000 {
				label = "MIBIB";
				reg = <0x40000 0x20000>;
			};

			partition@60000 {
				label = "QSEE";
				reg = <0x60000 0x60000>;
			};

			partition@c0000 {
				label = "CDT";
				reg = <0xc0000 0x10000>;
			};

			partition@d0000 {
				label = "DDRPARAMS";
				reg = <0xd0000 0x10000>;
			};

			partition@e0000 {
				label = "APPSBLENV";
				reg = <0xe0000 0x10000>;
			};

			partition@f0000 {
				label = "APPSBL";
				reg = <0xf0000 0x80000>;
			};

			partition@1 {
				label = "Bootloader";
				reg = <0 0x170000>;
			};

			partition@170000 {
				label = "ART";
				reg = <0x170000 0x10000>;
			};

			partition@180000 {
				label = "unused";
				reg = <0x180000 0xe80000>;
			};
		};
	};
};

&blsp1_uart1 {
	pinctrl-0 = <&serial_0_pins>;
	pinctrl-names = "default";
	status = "okay";
};

&cryptobam {
	status = "okay";
};

&nand {
	status = "okay";

	nand@0 {
		partitions {
			compatible = "fixed-partitions";
			#address-cells = <1>;
			#size-cells = <1>;

			rootfs_part1: partition@0 {
				label = "rootfs";
				reg = <0x0 0x4000000>;
			};

			rootfs_part2: partition@4000000 {
				label = "unused1";
				reg = <0x4000000 0x4000000>;
			};
		};
	};
};

&pcie0 {
	status = "okay";
	perst-gpio = <&tlmm 4 GPIO_ACTIVE_LOW>;
	wake-gpio = <&tlmm 40 GPIO_ACTIVE_HIGH>;

	/* Free slot for use */
	bridge@0,0 {
		reg = <0x00000000 0 0 0 0>;
		#address-cells = <3>;
		#size-cells = <2>;
		ranges;
	};
};

&qpic_bam {
	status = "okay";
};

&tlmm {
	mdio_pins: mdio_pinmux {
		mux_1 {
			pins = "gpio6";
			function = "mdio";
			bias-pull-up;
		};

		mux_2 {
			pins = "gpio7";
			function = "mdc";
			bias-pull-up;
		};
	};

	sd_0_pins: sd_0_pinmux {
		mux_1 {
			pins = "gpio23", "gpio24", "gpio25", "gpio26", "gpio28";
			function = "sdio";
			drive-strength = <10>;
		};

		mux_2 {
			pins = "gpio27";
			function = "sdio";
			drive-strength = <16>;
		};
	};

	serial_0_pins: serial0-pinmux {
		mux {
			pins = "gpio16", "gpio17";
			function = "blsp_uart0";
			bias-disable;
		};
	};

	led_pins: led_pinmux {
		mux {
			pins = "gpio32", "gpio39", "gpio50";
			function = "gpio";
			bias-pull-up;
			output-low;
		};

		mux_1 {
			pins = "gpio52";
			function = "gpio";
			bias-pull-up;
			output-high;
		};

		mux_2 {
			pins = "gpio61";
			function = "gpio";
			bias-pull-down;
			output-high;
		};
	};
};

&usb3_ss_phy {
	status = "okay";
};

&usb3_hs_phy {
	status = "okay";
};

&usb2_hs_phy {
	status = "okay";
};

&wifi0 {
	status = "okay";
	qcom,ath10k-calibration-variant = "R619AC";
};

&wifi1 {
	status = "okay";
	qcom,ath10k-calibration-variant = "R619AC";
};' > target/linux/ipq40xx/files-4.14/arch/arm/boot/dts/qcom-ipq4019-r619ac.dtsi

sed -i '${/$(eval $(call BuildImage))/d;}' target/linux/ipq40xx/image/Makefile
echo '
define Device/p2w_r619ac
	$(call Device/FitzImage)
	$(call Device/UbiFit)
	DEVICE_TITLE := P&W R619AC
	DEVICE_DTS := qcom-ipq4019-r619ac
	DEVICE_DTS_CONFIG := config@10
	BLOCKSIZE := 128k
	PAGESIZE := 2048
	IMAGES += nand-factory.bin
	IMAGE/nand-factory.bin := append-ubi | qsdk-ipq-factory-nand
	DEVICE_PACKAGES := ipq-wifi-p2w_r619ac
endef
TARGET_DEVICES += p2w_r619ac

$(eval $(call BuildImage))' >> target/linux/ipq40xx/image/Makefile

sed -i 's/qcom-ipq4019-a62.dtb/qcom-ipq4019-a62.dtb qcom-ipq4019-r619ac.dtb/' target/linux/ipq40xx/patches-4.14/901-arm-boot-add-dts-files.patch