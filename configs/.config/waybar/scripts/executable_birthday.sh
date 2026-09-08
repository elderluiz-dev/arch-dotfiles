#!/bin/bash

BIRTHDAYS_FILE="/home/g0shark/.config/waybar/scripts/birthdays.txt"
TODAY=$(date +%d.%m)
TOMORROW=$(date -d "+1 day" +%d.%m)

ICONS=""
TOOLTIP=""
CLASS=""  # CSS класс для Waybar

if [ ! -f "$BIRTHDAYS_FILE" ]; then
    ICONS="❌"
    TOOLTIP="Файл с днями рождения не найден"
else
    while IFS=: read -r NAME DATE; do
        NAME=$(echo "$NAME" | xargs)
        DATE=$(echo "$DATE" | xargs)

        if [ "$DATE" == "$TODAY" ]; then
            ICONS="🎂"
            TOOLTIP="$TOOLTIP\n$NAME — сегодня 🎉"
            CLASS="birthday-today"
        elif [ "$DATE" == "$TOMORROW" ]; then
            ICONS="🎂"
            TOOLTIP="$TOOLTIP\n$NAME — завтра"
            # CSS класс оставляем пустым
        fi
    done < "$BIRTHDAYS_FILE"

    if [ -z "$ICONS" ]; then
        ICONS="—"
        TOOLTIP="Нет дней рождения сегодня и завтра"
    fi
fi

TOOLTIP=$(echo "$TOOLTIP" | sed 's/^\\n//')

# JSON вывод для Waybar с возможным CSS классом
echo "{\"text\": \"$ICONS\", \"tooltip\": \"$TOOLTIP\", \"class\": \"$CLASS\"}"
