code=$(cat ~/.codecheck | grep XKBMAP= | cut -d '=' -f 2)
[ "$code" = "0" ] && code='us'
setxkbmap $code
service NetworkManager start
service dbus start
service alsasound start
exec startlxde
