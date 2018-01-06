#!/bin/bash
#
#
#
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. AT YOUR OWN RISK.
#
##################################################################################################################


##################################################################################################################
###################### C H E C K I N G   E X I S T E N C E   O F   F O L D E R S            ######################
##################################################################################################################b

# if there is already a folder in tmp, delete or else do nothing
[ -d /tmp/archlabs-conky-collection ] && rm -rf "/tmp/archlabs-conky-collection" || echo ""
# download the github in folder /tmp/archlabs-conky-collection

echo "################################################################"
echo "Checking if software is installed"

	# git

		# check if git is installed
		if ! location="$(type -p "git")" || [ -z "git" ]; then

			echo "################################################################"
			echo "installing git for this script to work"
			echo "################################################################"

		  	sudo pacman -S git

		  else
		  	echo "git was installed. Proceding..."
		fi

	# jq

		# check if git is installed
		if ! location="$(type -p "jq")" || [ -z "jq" ]; then

			echo "################################################################"
			echo "installing jq for the conky's to work"
			echo "################################################################"

		  	sudo pacman -S jq

		  else
		  	echo "jq was installed. Proceding..."
		fi

	# lm_sensors

		# check if git is installed
		if ! location="$(type -p "sensors")" || [ -z "sensors" ]; then

			echo "################################################################"
			echo "installing lm_sensors for the conky's to work"
			echo "################################################################"

		  	sudo pacman -S lm_sensors

		  else
		  	echo "lm_sensors was installed. Proceding..."
		fi


echo "################################################################"
echo "Downloading the files from github to tmp directory"


git clone https://github.com/ARCHLabs/Archlabs-Conky-Collection /tmp/archlabs-conky-collection


if [ -d ~/.config/conky ]; then
	echo "################################################################"
	echo "Making backup of current conky folder if there is one"
	curtime=$(date +%Y%m%d_%H%M%S)
	mkdir ~/.config/conky-backup-$curtime
	cp -r ~/.config/conky/* ~/.config/conky-backup-$curtime
	echo "Backup has been created at ~/.config/conky-backup-$curtime"
fi



##################################################################################################################
######################              C L E A N I N G  U P  O L D  F I L E S                    ####################
##################################################################################################################

# removing all the old files that may be in .config/conky with confirm deletion

if find ~/.config/conky -mindepth 1 > /dev/null ; then

	read -p "Everything in folder ~/.config/conky will be deleted. Are you sure? (y/n)?" choice
	case "$choice" in 
 	 y|Y ) rm -r ~/.config/conky/*;;
 	 n|N ) echo "Nothing has changed." & echo "Script ended!" & exit;;
 	 * ) echo "Type y or n." & echo "Script ended!" & exit;;
	esac

else
	echo "################################################################" 
	echo "Installation folder is ready and empty. Files will now be copied."

fi

##################################################################################################################
######################              M O V I N G  I N  N E W  F I L E S                        ####################
##################################################################################################################


# copy all config files to this hidden folder
echo "################################################################"
echo "Check if there is an ~./config/conky folder else create one"
if [ ! -d ~./config/conky ]; then
	mkdir -p $HOME"/.config/conky"
fi

cp -rf /tmp/archlabs-conky-collection/* ~/.config/conky
rm -rf /tmp/archlabs-conky-collection

echo "################################################################"
echo "In this hidden folder ~/.config/conky you will find your download."
echo "Use your menu to select the conky."
echo "################################################################"
echo "###################    T H E   E N D      ######################"
echo "################################################################"
