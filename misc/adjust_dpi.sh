dpi=${1:-144}

echo "Adjusting to a DPI of ${dpi}..."

> ~/.xsettingsd cat <<EOF
Xft/DPI $(( $dpi*1024 ))
Gdk/WindowScalingFactor $(( $dpi/96 ))
Gdk/UnscaledDPI $(( $dpi*1024/($dpi/96) ))
Xft/Antialias 1
#Xft/HintingStyle hintslight
#Xft/Hinting 1
#Xft/RGBA rgb
Net/EnableEventSounds 0
Net/EnableInputFeedbackSounds 0
#Net/IconThemeName Adwaita
#Net/SoundThemeName Adwaita
#Net/ThemeName Adwaita-dark
EOF
pkill -HUP xsettingsd || xsettingsd &

# For QT applications.
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# For miscellaneous applications.
echo Xft.dpi: $dpi | xrdb -merge
echo *.dpi: $dpi | xrdb -merge

FONT_SCALE=`echo $dpi/8.7 | bc`
SCRATCH_SCALE=`echo $dpi/6 | bc`
FUZZY_SCALE=`echo $dpi/4.8 | bc`
STREAM_SCALE=`echo $dpi/5.64 | bc`

FONT="xft:Iosevka SS05:style=Light"

echo "URxvt*.font:                   $FONT:pixelsize=$FONT_SCALE" | xrdb -merge
echo "urxvt-scratch.font:            $FONT:pixelsize=$SCRATCH_SCALE" | xrdb -merge
echo "urxvt-fuzzy.font:              $FONT:pixelsize=$FUZZY_SCALE" | xrdb -merge
echo "urxvt-stream.font:             $FONT:pixelsize=$STREAM_SCALE" | xrdb -merge
