#!/usr/bin/env bash

mkdir /opt/scripts
path=/opt/scripts/if.sh
cp if.sh $path
cp up-interface.service  /etc/systemd/system/
systemctl daemon-reload
systemctl enable up-interface.service

echo "Нужно ли менять имя машины? [y or n?]"
read answer
if [[ "$answer" == "y" || "$answer" = "Y" ]]; then
#Сменим имя машины
	old_name=$(uname -a | awk '{print ($2)}')
	echo "Введите новое имя сервера:"
	read name
	sed -i 's/'$old_name'/'$name'/g' /etc/hosts
	echo $name > /etc/hostname
	echo "Для применения новых настроек нужно перезагрузить сервер"
	exit
else 
	echo "Ну и ладно"
fi
