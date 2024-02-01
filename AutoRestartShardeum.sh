#!/bin/bash


mkdir -p "$HOME/AutoRestartShardeum"


SCRIPT_PATH="$HOME/AutoRestartShardeum/AutoRestart.sh"


cp "$0" "$SCRIPT_PATH"


chmod +x "$SCRIPT_PATH"


LOG_INFO="$HOME/AutoRestartShardeum/LogInfo.txt"
LOG_RESTART="$HOME/AutoRestartShardeum/LogRestart.txt"


result=$(docker exec shardeum-dashboard operator-cli status | grep -oP 'state:\s*\K\w+')


if [ -n "$result" ]; then
    datetime=$(date "+[%a %d %b %Y %H:%M:%S %Z]")
    echo "$datetime Status: $result" >> "$LOG_INFO"

    
    if [ "$result" = "stopped" ]; then
        echo "$datetime Шардеум зупинений, виконуємо рестарт..." >> "$LOG_INFO"
        echo "$datetime Restarted Sharduem" >> "$LOG_RESTART"
        docker exec shardeum-dashboard operator-cli start
    fi
fi
sleep 3


echo "alias checkshardeum='tail -n 288 $HOME/AutoRestartShardeum/LogInfo.txt && tail -n 25 $HOME/AutoRestartShardeum/LogRestart.txt'" >> ~/.bashrc


exec bash
