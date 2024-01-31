#!/bin/bash

# Шляхи до файлів журналів
LOG_INFO="$HOME/AutoRestartShardeum/LogInfo.txt"
LOG_RESTART="$HOME/AutoRestartShardeum/LogRestart.txt"

# Функція для виконання команди та запису результату в файл
execute_and_log() {
    # Виконати команду та отримати її результат
    result=$(docker exec shardeum-dashboard operator-cli status | grep -oP 'state:\s*\K\w+')
    
    # Перевірити, чи є результат виводу команди
    if [ -n "$result" ]; then
        # Записати результат у файл разом з українським часом
        datetime=$(date "+[%a %d %b %Y %H:%M:%S %Z]")
        echo "$datetime Status: $result" >> "$LOG_INFO"
        
        # Перевірити, чи значення state: stopped, і якщо так, виконати команду для запуску
        if [ "$result" = "stopped" ]; then
            echo "$datetime Sharduem was stopped, restarting..." >> "$LOG_INFO"
            echo "$datetime Restarted Sharduem" >> "$LOG_RESTART"
            docker exec shardeum-dashboard operator-cli start
        fi
    fi
}

# Викликати функцію execute_and_log
execute_and_log
