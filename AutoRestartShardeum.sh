#!/bin/bash

# Створення папки AutoRestartShardeum, якщо її не існує
mkdir -p "$HOME/AutoRestartShardeum"

# Перехід у папку .shardeum
cd "$HOME/.shardeum" || exit

# Встановлення українського часового поясу для команди date
export TZ="Europe/Kiev"

# Виконання команд та запис результатів у файли
{
    # Виконання shell.sh
    ./shell.sh

    # Затримка, щоб дати час завершити виконання ./shell.sh
    sleep 7
    
    # Виконання operator-cli status та зчитування значення статусу
    status=$(operator-cli status | awk '/state:/ {print $2}')
    
    # Затримка для забезпечення додаткового часу на отримання статусу
    sleep 7
    
    # Запис дати та часу у форматі українського часу
    datetime=$(date +"[%a %d %b %Y %I:%M:%S %p %Z]")
    
    # Запис статусу у файл LogInfo.txt разом з датою та часом
    echo "$datetime Status: $status" >> "$HOME/AutoRestartShardeum/LogInfo.txt"
    
    # Перевірка, чи значення статусу "stopped", і виконання команди operator-cli start
    if [ "$status" = "stopped" ]; then
        # Виконання команди operator-cli start
        operator-cli start
        
        # Запис виконання команди у файл LogAutoRestart.txt разом з датою та часом
        echo "$datetime Restarted Sharduem" >> "$HOME/AutoRestartShardeum/LogAutoRestart.txt"
    fi
} &> /dev/null
