#! /usr/bin/env bash

# CentOS 7 저장소를 보관(vault) 주소로 바꾼다. mirrorlist.centos.org는 CentOS 7 지원 종료 뒤 응답하지 않는다.
# vault.centos.org는 일부 파일(*.sqlite.bz2)을 막을 때가 있어 같은 보관본을 가진 미러를 함께 적는다.
# yum은 적은 순서대로 시도하고 받지 못하면 다음 주소로 넘어간다. 패키지는 CentOS 서명 키로 확인한다(gpgcheck=1).
cp -n /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.orig
for repo in os updates extras; do
  case $repo in os) id=base;; *) id=$repo;; esac
  cat <<EOF
[$id]
name=CentOS-7.9.2009 - $repo
baseurl=https://mirror.kakao.com/centos/7.9.2009/$repo/\$basearch/
        https://vault.centos.org/7.9.2009/$repo/\$basearch/
        https://archive.kernel.org/centos-vault/7.9.2009/$repo/\$basearch/
        https://ftp.iij.ad.jp/pub/linux/centos-vault/7.9.2009/$repo/\$basearch/
failovermethod=priority
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

EOF
done > /etc/yum.repos.d/CentOS-Base.repo
yum clean all
