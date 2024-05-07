exec 5> update.txt
BASH_XTRACEFD="5"
set -x

cd $(dirname $(readlink -f $0))

# Terminal colors
color_red="tput setaf 1"
color_green="tput setaf 2"
color_reset="tput sgr0"


fn_abort()
{
    $color_red; echo >&2 '
***************
*** ABORTED ***
***************
'
    echo "An error occurred. Exiting..." >&2; $color_reset
    exit 1
}

   trap 'fn_abort' 0
   set -e
   remote=$(
     git ls-remote -h origin master |
     awk '{print $1}'
   )
   local=$(git rev-parse HEAD)
   printf "Local : %s\nRemote: %s\n" $local $remote
   if [[ $local == $remote ]]; then
      dialog --title 'Update message' --infobox 'Commits match. Nothing update.' 4 35 ; sleep 2
   else
      dialog --title 'Update message' --infobox "Commits don't match. We update." 4 35 ; sleep 2
      git fetch origin master
      git reset --hard origin/master
      chmod u+x *.sh
   fi
   trap : 0
   dialog --title 'Update message' --infobox 'Update finished.' 4 20 ; sleep 2
   
   # We call updated install script passing through any quiet parameter
   if [ $# -eq 0 ]; then 
      ./install.sh
   else
      ./install.sh $1
   fi
