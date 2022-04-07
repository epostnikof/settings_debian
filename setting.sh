#!/usr/bin/env bash

#Check ROOT
if  [ "$(id -u)" != 0 ]
then
    echo root permission required >&2
    exit 1
fi

#Проверка наличия файлов
if [ -e /opt/scripts]
then
echo "Каталог '/opt/scripts' существует. Проверим наличие файла"
else
mkdir /opt/scripts
fi
# проверка существования файла
if [ -e if.sh ]
then
echo "Файл 'if.sh' присутствует. OK"
else
echo "Файл не существует, склонируйте репозиторий заново."
exit 1
fi
#
if [ -e up-interface.service ]
then
echo "Файл 'up-interface.service' присутствует. OK"
else
echo "Файл 'up-interface.service' не существует, склонируйте репозиторий заново."
exit 1
fi

echo "Будем ли поднимать сетевые интерфейсы в автоматически при запуске? [y or n]"
#Добавляем скрипт в автозагрузку
read answer2
if [ "$answer2" == "y" ] || [ "$answer2" == "Y" ]
 then
   mkdir /opt/scripts 2>/dev/null
   path=/opt/scripts/if.sh
   cp if.sh $path
   cp up-interface.service  /etc/systemd/system/
   systemctl daemon-reload
   systemctl enable up-interface.service
 else
#Выясняем какие сетевые интерфейсы выключены
IF=$(ip a | grep DOWN | awk -F: '{print ($2)}' | cut -d' ' -f2)
  #Поднимаем эти интерфейсы
  #Решил оставить так, потому что если интерфейсы подняты, то ничего не произойдёт.
IF_LIST= echo "$IF" > file
for var in $(cat file)
do
  ip link set dev $var up
  dhclient -v $var
done
  rm file
fi

echo "Нужно ли менять имя машины? [y or n?]"
read answer
if [ "$answer" == "y" ] || [ "$answer" = "Y" ]
 then
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
