exec 5> stop.txt
BASH_XTRACEFD="5"
set -x

cd $(dirname $(readlink -f $0))

source ./config.txt

fn_stop ()
{ # This is function stop
   sudo killall raspimjpeg 2>/dev/null
   sudo killall php 2>/dev/null
   sudo killall motion 2>/dev/null
}

#stop operation
fn_stop
