#   ---------------------------
#   COLORS
#   ---------------------------

# A more colorful prompt
c_reset='\[\e[0m\]'                                     # \[\e[0m\] resets the color to default color
c_path='\[\e[0;31m\]'                                   #  \e[0;31m\ sets the color to red
c_git_clean='\[\e[0;32m\]'                              # \e[0;32m\ sets the color to green
c_git_dirty='\[\e[0;31m\]'                              # \e[0;31m\ sets the color to red
black='\e[0;30m'
darkgray='\e[1;30m'
red='\e[0;31m'
light_red='\e[1;31m'
green='\e[0;32m'
light_green='\e[1;32m'
brown='\e[0;33m'
yellow='\e[1;33m'
blue='\e[0;34m'
light_blue='\e[1;34m'
purple='\e[0;35m'
light_purple='\e[1;35m'
cyan='\e[0;36m'
light_cyan='\e[1;36m'
light_gray='\e[0;37m'
white='\e[1;37m'

function clicolors() {
    i=1
    for color in {000..255}; do;
        c=$c"$FG[$color]$color✔$reset_color  ";
        if [ `expr $i % 8` -eq 0 ]; then
            c=$c"\n"
        fi
        i=`expr $i + 1`
    done;
    echo $c | sed 's/%//g' | sed 's/{//g' | sed 's/}//g' | sed '$s/..$//';
    c=''
}

