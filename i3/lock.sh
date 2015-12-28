

FILE=/tmp/screenshot.png

scrot $FILE
mogrify -scale 10% -scale 1000% $FILE
#mogrify -scale 10% -scale 1000% -gravity center -pointsize 40  -fill white -draw "text 0,50 'LOCKED!'" $FILE
i3lock -i $FILE
rm $FILE
