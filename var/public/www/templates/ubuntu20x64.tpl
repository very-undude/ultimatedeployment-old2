#cloud-config
autoinstall:
  version: 1
  # use interactive-sections to avoid an automatic reboot
  #interactive-sections:
  #  - locale
  apt:
    # even set to no/false, geoip lookup still happens
    #geoip: no
    preserve_sources_list: false
    primary:
    - arches: [amd64, i386]
      uri: http://us.archive.ubuntu.com/ubuntu
    - arches: [default]
      uri: http://ports.ubuntu.com/ubuntu-ports
  # r00tme
  identity: {hostname: focal-autoinstall, password: $6$.c38i4RIqZeF4RtR$hRu2RFep/.6DziHLnRqGOEImb15JT2i.K/F9ojBkK/79zqY30Ll2/xx6QClQfdelLe.ZjpeVYfE8xBBcyLspa/,
    username: ubuntu}
  keyboard: {layout: us, variant: ''}
  locale: en_US.UTF-8
  # interface name will probably be different
  network:
    network:
      version: 2
      ethernets:
        ens192:
          critical: true
          dhcp-identifier: mac
          dhcp4: true
  ssh:
    allow-pw: true
    authorized-keys: []
    install-server: true
  # this creates an efi partition, /boot partition, and root(/) lvm volume
  storage:
    grub:
      reorder_uefi: False
    swap:
      size: 0
    config:
    - {ptable: gpt, path: /dev/sda, preserve: false, name: '', grub_device: false,
      type: disk, id: disk-sda}
    - {device: disk-sda, size: 536870912, wipe: superblock, flag: boot, number: 1,
      preserve: false, grub_device: true, type: partition, id: partition-sda1}
    - {fstype: fat32, volume: partition-sda1, preserve: false, type: format, id: format-2}
    - {device: disk-sda, size: 1073741824, wipe: superblock, flag: linux, number: 2,
      preserve: false, grub_device: false, type: partition, id: partition-sda2}
    - {fstype: ext4, volume: partition-sda2, preserve: false, type: format, id: format-0}
    - {device: disk-sda, size: -1, flag: linux, number: 3, preserve: false,
      grub_device: false, type: partition, id: partition-sda3}
    - name: vg-0
      devices: [partition-sda3]
      preserve: false
      type: lvm_volgroup
      id: lvm-volgroup-vg-0
    - {name: lv-root, volgroup: lvm-volgroup-vg-0, size: 100%, preserve: false,
      type: lvm_partition, id: lvm-partition-lv-root}
    - {fstype: ext4, volume: lvm-partition-lv-root, preserve: false, type: format,
      id: format-1}
    - {device: format-1, path: /, type: mount, id: mount-2}
    - {device: format-0, path: /boot, type: mount, id: mount-1}
    - {device: format-2, path: /boot/efi, type: mount, id: mount-3}
write_files:
  # override the kernel package
  - path: /run/kernel-meta-package
    content: |
      linux-virtual
    owner: root:root
    permissions: "0644"
  # attempt to also use an answers file by providing a file at the default path.  It did not seem to have any effect
  #- path: /subiquity_config/answers.yaml
  #  content: |
  #    InstallProgress:
  #      reboot: no
  #  owner: root:root
  #  permissions: "0644"
