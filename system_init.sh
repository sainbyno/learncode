#!/bin/bash
#版本：1.0
#这个脚本是基于CentOS6.x 系列发行版本最小化安装的系统优化脚本！

#挂载光盘配置本地yum源
mkdir /mnt/cdrom
mount /dev/sr0 /mnt/cdrom
rm -rf /etc/yum.repos.d/*
cat > /etc/yum.repos.d/base.repo << eof
[os]
name=cdrom
baseurl=file:///mnt/cdrom
gpgcheck=0
eof
yum clean all

#下载配置autofs服务
yum -y install autofs
service autofs start
chkconfig autofs on

#用sed命令修改本地yum源路径
umount /mnt/cdrom
rm -rf /mnt/*
sed 's@mnt/cdrom@misc/cd@' /etc/yum.repos.d/base.repo
cd /misc/cd/
cd
yum clean all

#修改命令提示符颜色
cd /etc/profile.d
touch color.sh
echo 'export PS1="\[\e[33m\][\u@\h \W]\\$\[\e[0m\]"' > color.sh
. /etc/profile.d/color.sh

#关闭SElinux
sed -ri.bak 's/(^SELINUX=).*/\1permissive/' /etc/selinux/config

#关闭防火墙
chkconfig iptables off

#修改主机名
cat > /etc/sysconfig/network << eof
NETWORKING=yes
HOSTNAME=MiNi_6.9.wxg
eof

#重启系统
reboot
