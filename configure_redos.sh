#!/bin/bash
set -e

echo "Настройка Red OS"

echo "1. Настройка сетевого интерфейса"
nmcli connection modify "Проводное подключение 1" ipv4.addresses "192.168.1.1/29" ipv4.method "manual"

echo "2. Перезапуск сервиса NetworkManager"
systemctl restart NetworkManager

echo "3. Включение IP forwarding в /etc/sysctl.conf"
grep -q '^net.ipv4.ip_forward' /etc/sysctl.conf && \
    sed -i 's/^net.ipv4.ip_forward.*/net.ipv4.ip_forward=1/' /etc/sysctl.conf || \
    echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

echo "4. Применение настроек sysctl"
sysctl -p

echo "5. Настройка маскарадинга"
iptables -t nat -A POSTROUTING -s 192.168.1.0/29 -o enp0s3 -j MASQUERADE

echo "6. Сохранение правил iptables в /root/rules"
iptables-save > /root/rules

echo "7. Добавление команды восстановления правил iptables при перезапуске в crontab"
(crontab -l 2>/dev/null; echo "@reboot /sbin/iptables-restore < /root/rules") | crontab -

echo "Настройка Red OS завершена."
