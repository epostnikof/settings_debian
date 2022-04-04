#!/usr/bin/env bash

echo "Нужно ли настроить автоматически интерфейсы? [y or n?]"
read answer1
if [[ "$answer1" == "y" || "$answer1" = "Y" ]]; then
	mkdir /opt/scripts
	path=/opt/scripts/if.sh
	cp if.sh $path
	cp up-interface.service  /etc/systemd/system/up-interface.service
	systemctl daemon-reload
	systemctl enable up-interface.service
	echo "Все сетевые интерфейсы настроены в автоматическом режиме"
else
	echo "Значит всё работает как надо"
fi

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
