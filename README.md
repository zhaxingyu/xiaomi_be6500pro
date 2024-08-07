# xiaomi_be6500pro
BE6500PRO优化脚本

## 1.  挂载Overlay
ssh运行
```bash
mkdir -p /data/scripts
cd /data/scripts
curl -k -O https://raw.githubusercontent.com/zhaxingyu/xiaomi_be6500pro/main/auto_overlay.sh
chmod +x auto_overlay.sh
sh auto_overlay.sh install
reboot
```
卸载
```bash
sh /data/scripts/auto_overlay.sh uninstall
```
##  2.更换软件源
```bash
mkdir -p /data/scripts
cd /data/scripts
curl -k -O https://raw.githubusercontent.com/zhaxingyu/xiaomi_be6500pro/main/change_opkg_sources.sh
chmod +x change_opkg_sources.sh
sh change_opkg_sources.sh install
```
刷新软件包列表
```bash
opkg update
```
卸载
```bash
sh /data/scripts/change_opkg_sources.sh uninstall
```
##  3.ctemp显示CPU温度
###  3.1 已挂载Overlay
```bash
curl -k https://raw.githubusercontent.com/zhaxingyu/xiaomi_be6500pro/main/ctemp_overlaybase.sh | sh
```
卸载
```bash
rm /usr/bin/ctemp
```
###  3.2 未挂载Overlay
使用防火墙加载
```bash
mkdir -p /data/scripts
cd /data/scripts
curl -k -O https://raw.githubusercontent.com/zhaxingyu/xiaomi_be6500pro/main/ctemp.sh
chmod +x ctemp.sh
sh ctemp.sh install
```
卸载
```bash
sh /data/scripts/ctemp.sh uninstall
```
