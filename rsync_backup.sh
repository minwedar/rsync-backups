# /bin/bash

USERNAME=toddb
DEST_SERVER=computername

SOURCE=/Users/${USERNAME}
DEST=${USERNAME}@${DEST_SERVER}:/Volumes/Backup-Drive/Backup-Folder

echo "Source: " ${SOURCE}
echo "Destination: " ${DEST}

# Backup option is cool!  Now the --delete command doesn't feel so scary.
rsync_backup="--backup --backup-dir=rsync_backup/backup_$(date +%Y%m%d-%H%M%S) --exclude=rsync_backup"
rsync_excludes="--exclude=.DS_Store"
rsync_options="-ahvn --delete ${rsync_backup} ${rsync_excludes}"

if [ ! -d $DEST ]; then
   echo "Destination folder does not exist: ${DEST}"
   exit
fi

echo
echo "This is potintially very dangerous, are you sure?  Verify the source and output before proceeding..."
echo
read -p "Press [Enter] key to start backup..."

echo -e "\n\n"
echo -e "==========================================================================================="
echo "[`date`]"
echo -e "==========================================================================================="

# Under my user folder, I was doing the same call so I've condensed the folder I wanted into this for loop
for i in Documents Desktop temp scripts perforce
do
	#[ -d ${DEST}/$i ] || mkdir -p ${DEST}/$i      ## This was creating not a remote directory but local that looked remote...
	echo "rsync ${rsync_options} ${SOURCE}/$i/ ${DEST}/$i/"
	rsync ${rsync_options} ${SOURCE}/$i/ ${DEST}/$i/
done

# # Wanted to add another exclude to the Dropbox sync
echo -e "\n"
[ -d ${DEST}/Dropbox ] || mkdir -p ${DEST}/Dropbox
echo "rsync ${rsync_options} --exclude=".dropbox.cache" ${SOURCE}/Dropbox/ ${DEST}/Dropbox/"
rsync ${rsync_options} --exclude=".dropbox.cache" ${SOURCE}/Dropbox/ ${DEST}/Dropbox/


