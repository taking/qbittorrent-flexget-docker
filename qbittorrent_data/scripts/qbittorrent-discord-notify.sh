#!/bin/bash

# fork by fltd/qbittorrent-slack-notify.sh
# 
# this script is qBittorrent Discord Notify
# by taking

# A shell scirpt designed to be executed by qBittorrent's "Run external program on torrent completion"
# This scirpt will send a Discord notification using Discord's Incoming Webhooks with the information of completed torrent
#
# An example how to fill in qBittorrent's "Run external program on torrent completion" to execute this script
# /bin/bash -c "chmod +x /path/to/qbittorrent-discord-notify.sh; /path/to/qbittorrent-discord-notify.sh '%N' '%Z' 'https://discord.com/api/webhooks/XXXXXXXXXXXXXXXXXXXXXXXXX/YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY'"
#
# Supported parameters (case sensitive):
# - %N: Torrent name
# - %L: Category
# - %G: Tags (separated by comma)
# - %F: Content path (same as root path for multifile torrent)
# - %R: Root path (first torrent subdirectory path)
# - %D: Save path
# - %C: Number of files
# - %Z: Torrent size (bytes)
# - %T: Current tracker
# - %I: Info hash

# https://unix.stackexchange.com/a/259254
bytesToHuman() {
    b=${1:-0}; d=''; s=0; S=(Bytes {K,M,G,T,P,E,Y,Z}iB)
    while ((b > 1024)); do
        d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
        b=$((b / 1024))
        let s++
    done
    echo "$b$d ${S[$s]}"
}

name="$1"
if [ -z "$name" ]; then 
    echo "ERROR: Expected <name> as the 1st argument but none given, <name> should be the Torrent name (\"%N\") from qBittorrent"
    exit 1
fi

sizeBytes="$2"
if [ -z "$sizeBytes" ]; then 
    echo "ERROR: Expected <size> as the 2nd argument but none given, <size> should be the Torrent size (bytes) (\"%Z\") from qBittorrent"
    exit 1
fi
size=`bytesToHuman $sizeBytes`

discord_webhook="$3"
if [ -z "$discord_webhook" ]; then 
    echo "ERROR: Expected <discord_webhook> as the 3rd argument but none given, <discord_webhook> should be the incoming webhook for a channel obtained from Discord"
    exit 1
fi

ts=`date "+%r"`

/usr/bin/curl -sS \
    -X POST \
    -H 'Content-type: application/json' \
    -d "{\"username\": \"qBittorrent BOT\", \"avatar\": \"https://i.imgur.com/rEWsu2c.png\", \"title\": \"새로운 알람이 도착했습니다!\", \"content\": \"[다운로드 완료]\n - 파일 명 : $name\n - 파일 크기 : $size\n - 다운로드 완료 시간 : $ts\"}" \
    $discord_webhook

chown -R 1000:1000 /500GB_SSD
