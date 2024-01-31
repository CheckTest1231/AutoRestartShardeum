#!/bin/bash

# Створення папки AutoRestartShardeum, якщо її не існує
mkdir -p "$HOME/AutoRestartShardeum"

# Перехід у папку .shardeum
cd "$HOME/.shardeum" || exit

# Виклик команди через shell.sh та запис результатів
./shell.sh > "$HOME/AutoRestartShardeum/status.txt"

# Перевірка результатів та виконання необхідних дій
status=$(awk '/state:/ {print $2}' "$HOME/AutoRestartShardeum/status.txt")

# Запис дати та часу у форматі українського часу
datetime=$(date +"[%a %d %b %Y %I:%M:%S %p %Z]")

# Запис статусу у файл LogInfo.txt разом з датою та часом
echo "$datetime Status: $status" >> "$HOME/AutoRestartShardeum/LogInfo.txt"

# Перевірка, чи значення статусу "stopped", і виконання команди operator-cli start
if [ "$status" = "stopped" ]; then
    # Виконання команди operator-cli start
    ./shell.sh start
    
    # Запис виконання команди у файл LogAutoRestart.txt разом з датою та часом
    echo "$datetime Restarted Sharduem" >> "$HOME/AutoRestartShardeum/LogAutoRestart.txt"
fi
