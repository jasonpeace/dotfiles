#!/usr/local/bin/bash
cwd=$(pwd)
if [ -e ~/.m3udirs ]
    then
        # create an array of the lines
        readarray m3udirs < ~/.m3udirs
    else
        # teh default if no config found
        m3udirs=( "flac wav mp3 m4a" ~/Downloads )
fi

# reads the first line to get the list of file extensions to check for
read -a file_kinds <<< ${m3udirs[0]}

# slices off that first line so we only are left with full paths 
m3udirs=("${m3udirs[@]:1}")


for i in "${m3udirs[@]}"
do
    if [[ ${i:0:1} != '#' ]]
        then
        echo $i
            # should be a path that does not require shell expansion!
            if [ -e $i ]
                then
                    cd $i
                    find . -name '*.m3u' -print0 | xargs -0 rm
                    for j in "${file_kinds[@]}"
                        do
                            find . -iname \*.$j -execdir bash -c 'file="{}"; printf "%s\n" "${file##*/}" >> "${PWD##*/}.m3u"' \;
                        done
            fi
    fi   
done
cd $cwd
