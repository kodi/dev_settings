# play twitch stream by name, requires VLC to be installed 

function twitch() {
	if [ "$1" != "" ]
	then
		streamlink twitch.tv/$1 best
	fi
}
