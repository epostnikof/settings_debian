#!/usr/bin/env bash
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
