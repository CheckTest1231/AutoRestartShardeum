#!/bin/bash

# Створення папки для журналів та скрипта, якщо вони не існують
mkdir -p "$HOME/AutoRestartShardeum"

# Шлях до скрипта
SCRIPT_PATH="$HOME/AutoRestartShardeum/AutoRestart.sh"

# Копіювання скрипта в папку
cp "$0" "$SCRIPT_PATH"

# Надання дозволу на виконання скрипта
chmod +x "$SCRIPT_PATH"

# Шляхи до файлів журналів
LOG_INFO="$HOME/AutoRestartShardeum/LogInfo.txt"
LOG_RESTART="$HOME/AutoRestartShardeum/LogRestart.txt"

# Виконання команди та запис результату в файл
result=$(docker exec shardeum-dashboard operator-cli status | grep -oP 'state:\s*\K\w+')

# Перевірити, чи є результат виводу команди
if [ -n "$result" ]; then
    # Записати результат у файл разом з українським часом
    datetime=$(date "+[%a %d %b %Y %H:%M:%S %Z]")
    echo "$datetime Status: $result" >> "$LOG_INFO"

    # Перевірити, чи значення state: stopped, і якщо так, виконати команду для запуску
    if [ "$result" = "stopped" ]; then
        echo "$datetime Шардеум зупинений, виконуємо рестарт..." >> "$LOG_INFO"
        echo "$datetime Restarted Sharduem" >> "$LOG_RESTART"
        docker exec shardeum-dashboard operator-cli start
    fi
fi

# Додавання задачі крону для запуску скрипта кожні 5 хв
(crontab -l ; echo "*/5 * * * * /bin/bash $HOME/AutoRestartShardeum/AutoRestart.sh") | crontab -

# Почекати трохи, щоб зміни відобразилися
sleep 3

# Додати аліас для перевірки журналів
echo "alias checkshardeum='tail -n 288 $HOME/AutoRestartShardeum/LogInfo.txt && tail -n 25 $HOME/AutoRestartShardeum/LogRestart.txt'" >> ~/.bashrc

# Перезапустити оболонку, щоб зміни вступили в силу
exec bash
