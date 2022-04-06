convert -gravity NorthWest -background "rgba(255,255,255,0.65)" \
-size 250x40 -define pango:autodir=false pango:"$3" \
-append -size 250x20 label:"$4" \
-append -size 250x200 -define pango:align=left pango:@textsample.txt \
-append "$1"-1.png

convert "$1" -gravity Center -background "$6" -resize 800x600 -extent 800x600 "$1"-2.png

convert "$1"-2.png "$1"-1.png -gravity NorthWest -composite "$2".png

img2c RGB565 "$2".png > "$2".c

rm "$1"-2.png
rm "$1"-1.png
#rm "$2".png
