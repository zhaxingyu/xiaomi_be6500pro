cat << 'EOF' > /usr/bin/ctemp
#!/bin/sh

# 读取 CPU 温度
temp=$(cat /sys/class/thermal/thermal_zone0/temp)

# 使用 echo 和管道传递到 awk
echo "CPU Temp: $(echo "$temp" | awk '{printf "%.1f", $1/1000}')°C"
EOF

# 设置执行权限
chmod +x /usr/bin/ctemp

