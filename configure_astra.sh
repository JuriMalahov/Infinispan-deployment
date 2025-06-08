#!/bin/bash
set -e

echo "Настройка Astra Linux"

echo "1. Настройка сетевого интерфейса"
cat > /etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.1.2/29
    gateway 192.168.1.1
EOF

echo "2. Изменение /etc/resolv.conf"
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo "3. Отключение NetworkManager"
systemctl --now mask NetworkManager

echo "4. Перезапуск сервиса networking"
systemctl restart networking

echo "5. Обновление списка пакетов и установка SSH-сервера"
apt update && apt -y install openssh-server

echo "6. Настройка sshd_config"
sed -i 's/^#\?Port .*/Port 22/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

echo "7. Перезапуск sshd"
systemctl restart sshd

echo "Настройка Astra Linux завершена."
