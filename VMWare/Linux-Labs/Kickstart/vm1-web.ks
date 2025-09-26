# RHEL 10 Kickstart for Web Server (customized for devToluwa)

install
lang en_US.UTF-8
keyboard us
timezone Africa/Lagos
network --bootproto=dhcp --device=ens33 --onboot=on --hostname=web01
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
nginx
httpd
nano
%end

%users
toluwa --password=123456
%end

%post
echo "Web Server ready for devToluwa" > /etc/motd
echo "toluwa ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/toluwa
chmod 440 /etc/sudoers.d/toluwa
%end
