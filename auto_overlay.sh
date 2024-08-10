#!/bin/sh
script_dir="/data/scripts"
overlay_dir="/data/other_vol/overlay"
overlay_mount_point="/overlay"

mount_overlay() {
    # Check and create overlay directory and its subdirectories
    [ -e $overlay_dir ] || mkdir -p $overlay_dir
    [ -e $overlay_dir/upper ] || mkdir -p $overlay_dir/upper
    [ -e $overlay_dir/work ] || mkdir -p $overlay_dir/work
    # Bind the overlay directory to the mount point
    mount --bind $overlay_dir $overlay_mount_point
    # Source functions from the preinit script
    . /lib/functions/preinit.sh
    # Use fopivot to combine upper and work directories with /rom
    fopivot $overlay_mount_point/upper $overlay_mount_point/work /rom 1
    # Move and mount various directories to new locations
    /bin/mount -o noatime,move /rom/data /data 2>&-
    /bin/mount -o noatime,move /rom/etc /etc 2>&-
    /bin/mount -o noatime,move /rom/ini /ini 2>&-
    /bin/mount -o noatime,move /rom/userdisk /userdisk 2>&-
    echo -e "\033[32m Overlay mount complete. \033[0m"
}

install() {
    # Install overlay mount
    mount_overlay
    # Set firewall rules to include the auto mount script
    uci set firewall.auto_overlay=include
    uci set firewall.auto_overlay.type='script'
    uci set firewall.auto_overlay.path="${script_dir}/auto_overlay.sh"
    uci set firewall.auto_overlay.enabled='1'
    uci commit firewall
    echo -e "\033[32m Overlay auto-mount installed. \033[0m"
}

uninstall() {
    # Delete the auto mount firewall rule
    uci delete firewall.auto_overlay
    uci commit firewall
    echo -e "\033[33m Overlay auto-mount uninstalled. \033[0m"
}

main() {
    # If no parameter is provided, mount the overlay
    [ -z "$1" ] && mount_overlay && return
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
