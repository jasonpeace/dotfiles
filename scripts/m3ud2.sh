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
root_dirs=("${m3udirs[@]:1}")

IFS=$'\t\n'
m3udirs=($root_dirs)
for i in "${root_dirs[@]}"
    do
        if [[ ${i:0:1} != '#' ]]
            then
                cd $i
                m3udirs+=(`find * -maxdepth 3 -type d -exec realpath {} +`)
            
        fi
    done
unique_dirs=(`printf "%s\n" "${m3udirs[@]}" | sort -u`)
unset IFS


for i in "${unique_dirs[@]}"
do
    if [[ ${i:0:1} != '#' ]]
        then
            cd "$i"
            find . -name '*.m3u' -print0 | xargs -0 rm
            for j in "${file_kinds[@]}"
                do
                    filename=${PWD/*\//}.m3u
                    music_list=`ls -1vp | grep -i \.$j | grep -v /`
                    if [ $? -eq 0 ]
                        then
                            printf "%s\n" "${music_list[@]}"  >> "$filename"
                    fi
                done
    fi   
done
cd "$cwd"
