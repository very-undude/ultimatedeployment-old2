d-i debian-installer/locale string en_US
d-i console-setup/ask_detect boolean false
d-i console-setup/layoutcode string us
d-i netcfg/choose_interface select auto

#d-i netcfg/disable_dhcp boolean true
#d-i netcfg/get_nameservers string [NAMESERVERIP]
#d-i netcfg/get_ipaddress string [IPADDRESS]
#d-i netcfg/get_netmask string [NETMASK]
#d-i netcfg/get_gateway string [GATEWAY]
#d-i netcfg/confirm_static boolean true

d-i netcfg/get_hostname string unassigned-hostname
d-i netcfg/get_domain string unassigned-domain
d-i netcfg/wireless_wep string

d-i mirror/country string manual
d-i mirror/http/hostname string [UDA_IPADDR]
d-i mirror/http/directory string /[OS]/[FLAVOR]
d-i mirror/http/proxy string

d-i partman-auto/method string lvm
d-i partman-auto/purge_lvm_from_device boolean true

d-i partman-lvm/confirm boolean true
d-i partman-auto/choose_recipe select atomic

d-i partman/confirm_write_new_label boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true

d-i partman-lvm/confirm boolean true
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto-lvm/guided_size string max

#d-i partman-auto/disk string /dev/sda
#d-i partman-lvm/device_remove_lvm boolean true
#d-i partman-partitioning/confirm_write_new_label boolean true
#d-i partman/choose_partition select finish
#d-i partman/confirm boolean true
#d-i partman-lvm/confirm_nooverwrite boolean true


d-i clock-setup/utc boolean true
d-i time/zone string US/Eastern

d-i apt-setup/security_host string
#d-i apt-setup/local0/repository string \
#  deb http://[UDA_IPADDR]/[OS]/[FLAVOR] feisty main

d-i passwd/user-fullname string Ubuntu User
d-i passwd/username string ubuntu
# d-i passwd/user-password password secret
# d-i passwd/user-password-again password secret
d-i passwd/user-password-crypted password $1$dMNFlM93$vMFMataRaQkDjDLIN.m0f.

d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true

tasksel tasksel/first multiselect ubuntu-standard, ubuntu-desktop

d-i finish-install/reboot_in_progress note

xserver-xorg xserver-xorg/autodetect_monitor boolean true
xserver-xorg xserver-xorg/config/monitor/selection-method \
       select medium
xserver-xorg xserver-xorg/config/monitor/mode-list \
       select 1024x768 @ 60 Hz

