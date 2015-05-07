#!/bin/bash
cd ~/Downloads
find . -name '*.m3u' -print0 | xargs -0 rm
find . -iname '*.flac' -execdir bash -c 'file="{}"; printf "%s\n" "${file##*/}" >> "${PWD##*/}.m3u"' \;
find . -iname '*.wav' -execdir bash -c 'file="{}"; printf "%s\n" "${file##*/}" >> "${PWD##*/}.m3u"' \;
find . -iname '*.mp3' -execdir bash -c 'file="{}"; printf "%s\n" "${file##*/}" >> "${PWD##*/}.m3u"' \;
find . -iname '*.m4a' -execdir bash -c 'file="{}"; printf "%s\n" "${file##*/}" >> "${PWD##*/}.m3u"' \;
cd -
