#!/bin/bash

# Шляхи до файлів журналів
LOG_INFO="$HOME/AutoRestartShardeum/LogInfo.txt"
LOG_RESTART="$HOME/AutoRestartShardeum/LogRestart.txt"

# Збереження поточного статусу
current_status=$(docker exec shardeum-dashboard operator-cli status | grep -oP 'state:\s*\K\w+')

# Зчитування попереднього статусу з файлу, якщо він існує
if [ -f "$HOME/AutoRestartShardeum/prev_status.txt" ]; then
    previous_status=$(cat "$HOME/AutoRestartShardeum/prev_status.txt")
else
    previous_status=""
fi

# Перевірка, чи відбулася зміна статусу
if [ "$current_status" != "$previous_status" ]; then
    # Запис статусу в файл
    echo "$current_status" > "$HOME/AutoRestartShardeum/prev_status.txt"
    
    # Записати результат у файл разом з українським часом
    datetime=$(date "+[%a %d %b %Y %H:%M:%S %Z]")
    echo "$datetime Status: $current_status" >> "$LOG_INFO"

    # Перевірка, чи значення state: stopped, і якщо так, виконати команду для запуску
    if [ "$current_status" = "stopped" ]; then
        echo "$datetime Sharduem was stopped, restarting..." >> "$LOG_INFO"
        echo "$datetime Restarted Sharduem" >> "$LOG_RESTART"
        docker exec shardeum-dashboard operator-cli start
    fi
fi
