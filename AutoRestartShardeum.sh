#!/bin/bash

# Перевірка, чи існує папка AutoRestartShardeum, і створення її, якщо потрібно
mkdir -p "$HOME/AutoRestartShardeum"

# Перехід у папку .shardeum
cd "$HOME/.shardeum" || exit

# Виклик shell.sh
./shell.sh

# Безкінечний цикл для постійного виконання команди operator-cli status
while true; do
    # Отримання статусу через operator-cli
    status=$(operator-cli status | grep "state:" | awk '{print $2}')

    # Запис дати та часу
    datetime=$(date +"[%a %d %b %Y %I:%M:%S %p %Z]")

    # Запис статусу у файл LogInfo.txt разом з датою та часом
    echo "$datetime Status: $status" >> "$HOME/AutoRestartShardeum/LogInfo.txt"

    # Перевірка, чи статус "stopped", і виклик команди operator-cli start
    if [ "$status" = "stopped" ]; then
        # Виклик команди operator-cli start
        operator-cli start

        # Запис виклику команди у файл LogAutoRestart.txt разом з датою та часом
        echo "$datetime Restarted Sharduem" >> "$HOME/AutoRestartShardeum/LogAutoRestart.txt"
    fi

    # Очікування 1 хвилини перед наступною ітерацією циклу
    sleep 60
done
