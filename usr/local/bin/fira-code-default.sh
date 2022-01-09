#!/usr/bin/env bash

## Change all fonts on the system to Fira Code by default.

## Directories.
pdir="$HOME/.config/polybar"
rdir="$HOME/.config/rofi"
tdir="$HOME/.config/alacritty"
odir="$HOME/.config/openbox"
ddir="$HOME/.config/dunst"

## Check for library inclusion.
if ! . "/usr/lib/archlabs/common/al-include.cfg" 2>/dev/null; then
    echo $"Error: Failed to source /usr/lib/archlabs/common/al-include.cfg" >&2 ; exit 1
fi

## Prepare the Fira Code font.
getfonts () {
	FONT=$(echo "Fira Code|Regular|12")
	FNAME=$(echo $FONT | cut -d'|' -f1)
	FSTYLE=$(echo $FONT | cut -d'|' -f2)
	FSIZE=$(echo $FONT | cut -d'|' -f3)
}

## Update the Polybar font.
font_bar () {
	if [[ "$FONT" ]]; then
		PSTYLE=$(cat $pdir/launch.sh | grep STYLE | head -n 1 | tr -d 'STYLE=' | tr -d \")
		sed -i -e "s/font-0 = .*/font-0 = $FNAME:$FSTYLE:size=$FSIZE;2/g" $pdir/"$PSTYLE"/config.ini
		polybar-msg cmd restart
	else
		exit 0
	fi
}

## Update the Rofi font.
font_rofi () {
	if [[ "$FONT" ]]; then
		RSTYLE=$(cat $rdir/bin/mpd | grep STYLE | head -n 1 | tr -d 'STYLE=' | tr -d \")
		sed -i -e "s/font:.*/font:				 	\"$FNAME $FSTYLE $FSIZE\";/g" $rdir/"$RSTYLE"/font.rasi
		sed -i -e "s/font:.*/font:				 	\"$FNAME $FSTYLE $FSIZE\";/g" "$rdir/dialogs/askpass.rasi" "$rdir/dialogs/confirm.rasi"
	else
		exit 0
	fi
}

## Update the Terminal font.
font_term () {
	if [[ "$FONT" ]]; then
		sed -i -e "s/font = .*/font = $FNAME $FSTYLE $FSIZE/g" $tdir/config
		killall -USR1 alacritty
	else
		exit 0
	fi
}

## Update the font used by Openbox.
font_ob () {
	if [[ "$FONT" ]]; then
		namespace="http://openbox.org/3.4/rc"
		config="$odir/rc.xml"

		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:name' -v "$FNAME" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:size' -v "$FSIZE" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:weight' -v Bold "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveWindow"]/a:slant' -v Normal "$config"

		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:name' -v "$FNAME" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:size' -v "$FSIZE" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:weight' -v Normal "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveWindow"]/a:slant' -v Normal "$config"

		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:name' -v "$FNAME" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:size' -v "$FSIZE" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:weight' -v Bold "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuHeader"]/a:slant' -v Normal "$config"

		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:name' -v "$FNAME" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:size' -v "$FSIZE" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:weight' -v Normal "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="MenuItem"]/a:slant' -v Normal "$config"

		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:name' -v "$FNAME" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:size' -v "$FSIZE" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:weight' -v Bold "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="ActiveOnScreenDisplay"]/a:slant' -v Normal "$config"

		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:name' -v "$FNAME" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:size' -v "$FSIZE" "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:weight' -v Normal "$config"
		xmlstarlet ed -L -N a="$namespace" -u '/a:openbox_config/a:theme/a:font[@place="InactiveOnScreenDisplay"]/a:slant' -v Normal "$config"

		openbox --reconfigure
	else
		exit 0
	fi
}

## Update the Dunst font.
font_dunst () {
	if [[ "$FONT" ]]; then
		sed -i -e "s/font = .*/font = $FNAME $FSTYLE $FSIZE/g" $ddir/dunstrc
		pkill dunst && dunst &
	else
		exit 0
	fi
}

## Update the GTK font.
font_gtk () {
	if [[ "$FONT" ]]; then
		xfconf-query -c xsettings -p /Gtk/FontName -s "$FNAME $FSTYLE $FSIZE"
	else
		exit 0
	fi
}

## Perform all font changes and exit.
getfonts
font_bar
font_rofi
font_ob
font_dunst
font_gtk
font_term
exit 0
