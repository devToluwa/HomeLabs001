# RHEL 10 Kickstart for Database Server

install
lang en_US.UTF-8
keyboard us
timezone Africa/Lagos
network --bootproto=dhcp --device=ens33 --onboot=on --hostname=db01
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
mariadb-server
postgresql-server
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
