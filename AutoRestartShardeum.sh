#!/bin/bash

# Встановлення абсолютного шляху до operator-cli
OPERATOR_CLI="/usr/local/bin/operator-cli"

# Створення папки AutoRestartShardeum, якщо її не існує
mkdir -p "$HOME/AutoRestartShardeum"

# Перехід у папку .shardeum
cd "$HOME/.shardeum" || exit

# Виклик команди через shell.sh та запис результатів
sudo ./shell.sh > "$HOME/AutoRestartShardeum/status.txt"

# Перевірка результатів та виконання необхідних дій
status=$(awk '/state:/ {print $2}' "$HOME/AutoRestartShardeum/status.txt")

# Запис дати, часу та статусу у файл LogInfo.txt
datetime=$(date +"[%a %d %b %Y %I:%M:%S %p %Z]")
echo "$datetime Status: $status" >> "$HOME/AutoRestartShardeum/LogInfo.txt"

# Перевірка, чи значення статусу "stopped", і виконання команди
if [ "$status" = "stopped" ]; then
    sudo "$OPERATOR_CLI" start
    echo "$datetime Restarted Sharduem" >> "$HOME/AutoRestartShardeum/LogAutoRestart.txt"
fi
