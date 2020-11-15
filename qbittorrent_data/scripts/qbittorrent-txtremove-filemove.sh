#!/bin/bash

# 이 스크립트는 토렌트 다운로드 시, 폴더로 받아지는 경우 다음과 같은 작업을 진행한다.
# 1. 폴더 내 txt 가 있는 경우 제거
# 2. 폴더 내 mkv, mp4 확장자가 있는 경우, 다운로드 루트 폴더로 이동
#  - down-folder\test\1.mp4 -> down-folder\1.mp4
# 3. 빈 폴더는 삭제
# by taking

# A shell scirpt designed to be executed by qBittorrent's "Run external program on torrent completion"
# An example how to fill in qBittorrent's "Run external program on torrent completion" to execute this script
# /bin/bash -c "chmod +x /path/to/qbittorrent-txtremove-filemove.sh; /path/to/qbittorrent-txtremove-filemove.sh '%D'"
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

downpath="$1"
if [ -z "$downpath" ]; then 
    echo "ERROR: Expected <downpath> as the 1st argument but none given, <downpath> should be the Torrent Download Path (\"%D\") from qBittorrent"
    exit 1
fi
echo 'downpath is' $downpath

find $downpath/* -maxdepth 2 -type f -iregex '.*.\.\(mkv\|mp4\|wmv\|flv\|webm\|avi\|mov\)'  -size +1k -exec mv -t $downpath {} +
find $downpath/* -maxdepth 2 -type f -iregex '.*.\.\(smi\|srt\)'  -size +1k -exec mv -t $downpath {} +
find $downpath/* -name "*.url" -type f -exec rm {} +
find $downpath/* -depth -type d -empty -exec rmdir {} \;

chown -R 1000:1000 $downpath
