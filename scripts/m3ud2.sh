#!/usr/local/bin/bash
cwd=$(pwd)
if [ -e ~/.m3udirs ]
    then
        readarray m3udirs < ~/.m3udirs
    else
        m3udirs=( "flac wav mp3 m4a" ~/Downloads )
fi

read -a file_kinds <<< ${m3udirs[0]}


m3udirs=("${m3udirs[@]:1}")


for i in "${m3udirs[@]}"
do
    if [ -e $i ]
        then
            cd $i
            find . -name '*.m3u' -print0 | xargs -0 rm
            for j in "${file_kinds[@]}"
                do
                    find . -iname \*.$j -execdir bash -c 'file="{}"; printf "%s\n" "${file##*/}" >> "${PWD##*/}.m3u"' \;
                done
    fi   
done
cd $cwd
