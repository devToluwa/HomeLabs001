# RHEL 10 Kickstart for Monitoring Server (monitor01)

install
lang en_US.UTF-8
keyboard us
timezone Africa/Lagos
network --bootproto=dhcp --device=ens33 --onboot=on --hostname=monitor01
rootpw 123456
firewall --enabled
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
services --enabled=sshd
bootloader --location=mbr
clearpart --all --initlabel
autopart --type=lvm
reboot

%packages
@core
grafana
prometheus
nano
%end

%users
toluwa --password=123456
%end

%post

echo "Monitoring Server (monitor01) ready for devToluwa" > /etc/motd
echo "toluwa ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/toluwa
chmod 440 /etc/sudoers.d/toluwa
%end
