#!/usr/bin/env bash
#Выясняем какие интерфейсы опущены
IF=$(ip a | grep DOWN | awk '{print ($2)}' | tr ':' '\n')
echo $IF >> o.txt
cat o.txt | tr ' ' '\n' >> file
#Это костыль, но я не смог найти способ сделать проще и чтобы работало. Главное, что работает без отказно.


#Поднимаем эти интерфейсы
for var in $(cat file)
do
ip link set dev $var up
dhclient -v $var
done
rm file
rm o.txt
