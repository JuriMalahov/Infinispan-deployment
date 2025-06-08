#!/bin/bash
set -e

echo "Настройка Alt Linux"

echo "1. Настройка сетевого интерфейса"
echo "BOOTPROTO=static
TYPE=eth
NM_CONTROLLED=no
DISABLED=no" > /etc/net/ifaces/enp0s3/options

echo "192.168.1.3/29" > /etc/net/ifaces/enp0s3/ipv4address
echo "default via 192.168.1.1" > /etc/net/ifaces/enp0s3/ipv4route

echo "2. Перезапуск сервиса network"
systemctl restart network
systemctl restart network

echo "3. Обновление списка пакетов и установка SSH-сервера"
apt-get update && apt-get -y install openssh-server

echo "4. Настройка sshd_config"
sed -i 's/^#\?Port .*/Port 22/' /etc/openssh/sshd_config
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/openssh/sshd_config

echo "5. Активация и перезапуск sshd"
systemctl enable sshd

echo "6. Генерация SSH-ключа"
ssh-keygen -N ""

echo "7. Копирование ключей на хосты alt и astra"
ssh-copy-id -o StrictHostKeyChecking=no "root@192.168.1.2"
ssh-copy-id -o StrictHostKeyChecking=no "root@192.168.1.3"

echo "8. Установка git и ansible"
apt-get -y install git ansible

echo "Настройка Alt Linux завершена."
