#!/bin/sh
script_dir="/data/scripts"

change_sources() {
    # Modify Architecture Arguments
    cp /etc/opkg.conf /etc/opkg.conf.bak
    echo -e "arch all 100\narch aarch64_cortex-a53_neon-vfpv4 200\narch aarch64_cortex-a53 300" >> /etc/opkg.conf
    # Change opkg sources
    mv /etc/opkg/distfeeds.conf /etc/opkg/distfeeds.conf.bak
    echo -e "src/gz openwrt_base http://mirrors.ustc.edu.cn/openwrt/snapshots/packages/aarch64_cortex-a53/base" >> /etc/opkg/distfeeds.conf
    echo -e "src/gz openwrt_luci http://mirrors.ustc.edu.cn/openwrt/snapshots/packages/aarch64_cortex-a53/luci" >> /etc/opkg/distfeeds.conf
    echo -e "src/gz openwrt_packages http://mirrors.ustc.edu.cn/openwrt/snapshots/packages/aarch64_cortex-a53/packages" >> /etc/opkg/distfeeds.conf
    echo -e "src/gz openwrt_routing http://mirrors.ustc.edu.cn/openwrt/snapshots/packages/aarch64_cortex-a53/routing" >> /etc/opkg/distfeeds.conf
    echo -e "src/gz openwrt_telephony http://mirrors.ustc.edu.cn/openwrt/snapshots/packages/aarch64_cortex-a53/telephony" >> /etc/opkg/distfeeds.conf
}

install() {
    change_sources

    #Auto Start Using Firewall
    uci set firewall.change_opkg_sources=include
    uci set firewall.change_opkg_sources.type='script'
    uci set firewall.change_opkg_sources.path="${script_dir}/change_opkg_sources.sh"
    uci set firewall.change_opkg_sources.enabled='1'
    uci commit firewall
    echo -e "\033[32m Auto Opkg Source Change installed. \033[0m"
}

uninstall() {
    # Remove firewall rules
    uci delete change_opkg_sources
    uci commit firewall
    mv /etc/opkg/distfeeds.conf.bak /etc/opkg/distfeeds.conf
    mv /etc/opkg.conf.bak /etc/opkg.conf
    echo -e "\033[33m Auto Opkg Source Change uninstalled. \033[0m"
}

main() {
    [ -z "$1" ] && change_sources && return
    case "$1" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    *)
        echo -e "\033[31m Unknown parameter: $1 \033[0m"
        return 1
        ;;
    esac
}

main "$@"
