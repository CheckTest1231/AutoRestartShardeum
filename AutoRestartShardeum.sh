#!/bin/bash

# Створення папки AutoRestartShardeum, якщо її не існує
mkdir -p $HOME/AutoRestartShardeum

# Перехід у папку .shardeum
cd $HOME/.shardeum

# Виконання команд та запис результатів у файли
{
    # Виконання shell.sh
    ./shell.sh
    
    # Виконання operator-cli status та зчитування значення "state"
    status=$(operator-cli status | grep "state:" | awk '{print $2}')
    
    # Запис дати та часу
    datetime=$(date)
    
    # Запис статусу у файл LogInfo.txt разом з датою та часом
    echo "[$datetime] Status: $status" >> $HOME/AutoRestartShardeum/LogInfo.txt
    
    # Перевірка, чи значення статусу "stopped", і виконання команди operator-cli start
    if [ "$status" = "stopped" ]; then
        # Виконання команди operator-cli start
        operator-cli start
        
        # Запис виконання команди у файл LogAutoRestart.txt разом з датою та часом
        echo "[$datetime] Restarted Sharduem" >> $HOME/AutoRestartShardeum/LogAutoRestart.txt
    fi
} &> /dev/null
