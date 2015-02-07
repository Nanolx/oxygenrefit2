#!/bin/bash

BASEDIR="$PWD"
TARGET=""

SIZES_TO_SYNC="16x16 24x24 32x32 48x48"
DIRS_TO_SYNC="actions apps apps-extra apps-evolution emblems categories devices mimetypes places status emotes stock"
TEMPLATE_SIZE="128x128"

case $1 in

	*naming)
		cd $BASEDIR/$TEMPLATE_SIZE
		for category in actions apps categories devices mimetypes places status;
			do cd $category && \
			echo "===============" && echo -e "icon-mapping for 128x128/$category" && \
			/usr/lib/icon-naming-utils/icon-name-mapping  -c $category >/dev/null && cd ..; \
		done
		exit 0
	;;

	*help)
		echo "usage: ./build.sh naming -> use icon-naming-utils"
		echo "usage: ./build.sh <size> -> create images of <size>"
		exit 0
	;;
esac

echo "==============="
echo "Starting"
rm -rf $SIZES_TO_SYNC

	for size in $SIZES_TO_SYNC;
		do cp -r 128x128 --preserve=links $size && \
			for dir in $DIRS_TO_SYNC;
				do echo "===============" && \
				echo -e "creating $size/$dir" && cd $size/$dir && \
				for icon in $(ls -1 -F | grep -v @ | sed -e 's/\*//g')
					do mogrify -resize $size! $icon; \
				done;\
				cd $BASEDIR
			done; \
	done
echo "==============="
echo "symlinking duplicates"

for size in $SIZES_TO_SYNC 128x128;
	do cd $BASEDIR/$size && \
	for dir in $DIRS_TO_SYNC;
		do cd $BASEDIR/$size/$dir && \
		fdupes . | while read LINE; do
		if [ -z "$LINE" ]; then
			TARGET=""
		elif [ -z "$TARGET" ]; then
			TARGET=${LINE/$BASEDIR\/$size\/$dir/}
		else
			ln -sf "$TARGET" "$LINE"
		fi ; \
		done; \
	cd $BASEDIR; \
	done; \
done

echo "==============="
echo "cleaning up"
cd $BASEDIR
rm -f *~

echo "==============="
echo "Finished"
echo "==============="
