# System settings before starting X
. $HOME/.bashrc

PATH=$PATH:$HOME/bin

# set up alsa
/usr/bin/amixer sset Master Mono 90% unmute  &> /dev/null
/usr/bin/amixer sset Master 90% unmute  &> /dev/null
/usr/bin/amixer sset PCM 90% unmute &> /dev/null

# Start x on login
if [[ -z $DISPLAY && ! -e /tmp/.X11-unix/X0 ]]; then
   exec xinit -- /usr/bin/X -nolisten tcp vt7
fi


