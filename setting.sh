#!/usr/bin/env bash

#Check ROOT
if  [ "$(id -u)" != 0 ]
then
    echo root permission required >&2
    exit 1
fi

echo "Нужно ли чтобы сетевые интерфейсы были подняты всегда? [y or n]"
read answer2
if [[ "$answer2" == "y" || "$answer2" == "Y" ]]; then
  mkdir /opt/scripts 2>/dev/null
  path=/opt/scripts/if.sh
  cp if.sh $path
  cp up-interface.service  /etc/systemd/system/
  systemctl daemon-reload
  systemctl enable up-interface.service
else
#Выясняем какие интерфейсы подняты
IF=$(ip a | grep DOWN | awk '{print ($2)}' | tr ':' '\n')
echo $IF >> o.txt
cat o.txt | tr ' ' '\n' >> file
#Это костыль, но я не смог найти способ сделать проще и чтобы работал

  #Поднимаем эти интерфейсы
  #Решил оставить так, потому что если интерфейсы подняты, то ничего не произойдёт.
for var in $(cat file)
do
  ip link set dev $var up
  dhclient -v $var
done
  rm file
  rm o.txt
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
