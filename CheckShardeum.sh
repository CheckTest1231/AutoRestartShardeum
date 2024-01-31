#!/bin/bash

function printGreen {
  echo -e "\e[1m\e[32m${1}\e[0m"
}

echo ""
printGreen "Останні 36 записи(3год роботи) записи файлу LogInfo.txt"
tail -n 36 $HOME/AutoRestartShardeum/LogInfo.txt
echo ""
printGreen "Останні 25 записів файлу LogRestart.txt"
tail -n 24 $HOME/AutoRestartShardeum/LogRestart.txt
echo ""
