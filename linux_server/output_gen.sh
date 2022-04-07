convert -gravity NorthWest -background "rgba(255,255,255,0.65)" \
-size 250x40 -font "/usr/share/fonts/truetype/noto/NotoSans-Regular.ttf" label:"$3" \
-append -size 250x20 -font "/usr/share/fonts/truetype/noto/NotoSans-Regular.ttf" label:"$4" \
-append -size 250x200 -font "/usr/share/fonts/truetype/noto/NotoSans-Regular.ttf" caption:"$5" \
-append -size 250x30 -font "/usr/share/fonts/truetype/noto/NotoSans-Regular.ttf" label:"$6" \
-append "$1"-1.png

convert "$1" -gravity Center -background "$7" -resize 800x600 -extent 800x600 "$1"-2.png

convert "$1"-2.png "$1"-1.png -gravity NorthWest -geometry +0+13 -composite "$2".png

img2c RGB565 "$2".png > "$2".c

rm "$1"-2.png
rm "$1"-1.png
#rm "$2".png