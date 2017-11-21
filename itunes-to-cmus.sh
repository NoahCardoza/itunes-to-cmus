XML="$HOME/Music/iTunes/iTunes Music Library.xml";
if [ ! -f "$XML" ]; then
	echo "ERROR: Make sure to share your iTunes library XML with other applications." >&2;
	echo "(iTunes > Preferences > Advanced > Share iTunes Library XML with other applications)" >&2;
	exit;
fi
PID=$(/usr/libexec/PlistBuddy "$XML" -c "print :Playlists" | grep "Name = " | grep -nE "Name = $1$" | cut -d: -f1);
if [ ! $PID ]; then
	echo "ERROR: Playlist not found." >&2;
	exit;
fi
PID=$(expr "$PID" - 1)
IDS=$(/usr/libexec/PlistBuddy "$XML" -c "print :Playlists:$PID:\"Playlist Items\"" | grep -Eo "\d+");
for ID in $IDS; do
	/usr/libexec/PlistBuddy "$XML" -c "print :Tracks:$ID:Location" | tail -c +8 | sed 's/%20/ /g'
done
