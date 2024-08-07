#!/bin/sh
script_dir="/data/scripts"

ctemp(){
# 检查文件是否存在
if [ ! -f /usr/bin/ctemp ]; then
  cat << 'EOF' > /usr/bin/ctemp
#!/bin/sh

# 读取 CPU 温度
temp=$(cat /sys/class/thermal/thermal_zone0/temp)

# 使用 echo 和管道传递到 awk
echo "CPU Temp: $(echo "$temp" | awk '{printf "%.1f", $1/1000}')°C"
EOF

  # 设置执行权限
  chmod +x /usr/bin/ctemp
else
  echo "ctemp 已经存在，跳过创建。"
fi
}

install() {
    # Install overlay mount
    ctemp
    # Set firewall rules to include the auto mount script
    uci set firewall.ctemp=include
    uci set firewall.ctemp='script'
    uci set firewall.ctemp.path="${script_dir}/ctemp.sh"
    uci set firewall.ctemp.enabled='1'
    uci commit firewall
    echo -e "\033[32m ctemp installed. \033[0m"
}

uninstall() {
    # Delete the auto mount firewall rule
    rm /usr/bin/ctemp
    uci delete firewall.ctemp
    uci commit firewall
    echo -e "\033[33m ctemp uninstalled. \033[0m"
}

main() {
    # If no parameter is provided, run ctemp
    [ -z "$1" ] && ctemp && return
    case "$1" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    *)
        # Handle unknown parameters
        echo -e "\033[31m Unknown parameter: $1 \033[0m"
        return 1
        ;;
    esac
}

main "$@"
