set -e

# Errors can be located by just running the c preprocessor
# cpp glove80.keymap -I/opt/zmk_glove80/zmk/app/dts/ -I/opt/zmk_glove80/zmk/app/include/

DIR=/opt/zmk_glove80

source $DIR/venv/bin/activate

CFGDIR=$DIR/glove80-zmk-config/config
BASE=$DIR/zmk
APP=$BASE/app
BUILD=$CFGDIR/build

cd $APP

for hand in left right; do
	BOARD=glove80_${hand:0:1}h
	west build -b $BOARD -d $BUILD/$hand/ -- -DZMK_CONFIG=$CFGDIR
	cp $BUILD/$hand/zephyr/zmk.uf2 $CFGDIR/$hand.uf2
done
