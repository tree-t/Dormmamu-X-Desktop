#!/bin/bash

# Note: This file a modified version of fbappselect(from S.L.A.X 9.x) (written by Tomas-M)
# Original Writer: Tomas Matejicek
# Editor : Tree-t

COMMAND=$(
  xlunch_genquick 64 --desktop | \
  xlunch --border 7% --sideborder 10% --borderratio 100 --sideborderratio 50 \
         --background ~/.config/awesome/wallpaper.jpg \ #--font DejaVuSans/11 \
         --voidclickterminate --iconpadding 40 --textpadding 10 \
         --leastmargin 6 --hidemissing --iconsize 64 \
         --highlight /usr/share/icons/hicolor/128x128/apps/xlunch_highlight.png \
         --outputonly
)

if [ "$COMMAND" = "" ]; then
   exit
fi

# if command is a .desktop file, parse it
if [[ "$COMMAND" =~ \.desktop ]]; then
   NoTerm="$(cat "$COMMAND" | grep Terminal\\s*= | grep -i "Terminal\\s*=\\s*false")"
   COMMAND="$(cat "$COMMAND" | grep Exec\\s*= | head -n 1 | sed -r s/.*=// | sed -r "s/%[^%]+//g")"
fi

cmd="$(echo $COMMAND | sed -r "s/\\s.*//")"
whi="$(which $cmd | head -n 1)"
Xdep=$(ldd $whi | grep libX11)
Ndep=$(ldd $whi | grep libncurses)

WAIT='echo "--------------------------------------------------"; read -n 1 -s -r -p "Command finished. Press any key to close window..."'
if [ "$Ndep" != "" -o "$cmd" = "man" -o "$cmd" = "mc" ]; then
   WAIT=""
fi

if [ "$Xdep" = "" -a "$cmd" != "chromium" -a "$cmd" != "wicd-manager" -a "$cmd" != "fbliveapp" -a "$NoTerm" = "" ]; then
   exec xterm -ls -e bash --login -c -- "echo $USER@$HOSTNAME:$PWD# '$COMMAND'; $COMMAND; $WAIT"
else
   exec $COMMAND
fi
