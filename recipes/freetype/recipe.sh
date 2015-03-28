#!/bin/bash

VERSION_freetype=${VERSION_freetype:-2.5.5}
DEPS_freetype=(harfbuzz)
URL_freetype=http://download.savannah.gnu.org/releases/freetype/freetype-2.5.5.tar.gz
MD5_freetype=7448edfbd40c7aa5088684b0a3edb2b8
BUILD_freetype=$BUILD_PATH/freetype/$(get_directory $URL_freetype)
RECIPE_freetype=$RECIPES_PATH/freetype

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_freetype() {
	true
}

#~ function shouldbuild_freetype() {
    #~ if [ -f "$BUILD_freetype/libfreetype.so" ]; then
		#~ DO_BUILD=0
	#~ fi
#~ }

function build_freetype() {
	cd $BUILD_freetype

	push_arm
    export LDFLAGS="$LDFLAGS -L$BUILD_harfbuzz/src/.libs/"
    echo $SRC_PATH
    echo $BUILD_harfbuzz
    #return
	#~ export CC="$CC -I$BUILD_libfreetype/include"
	#~ export LDFLAGS="$LDFLAGS -L$LIBS_PATH"
	#~ export LDSHARED="$LIBLINK"

    #export LDSHARED="$LIBLINK"
    # http://en.wikibooks.org/wiki/OpenGL_Programming/Installation/Android_NDK#FreeType


    #try sh autogen.sh
	try ./configure --build=i686-pc-linux-gnu --host=arm-linux-androideabi --prefix="$BUILD_PATH/python-install" --without-zlib --with-png=no --enable-shared
	try make -j5
	pop_arm
    echo 'finished'
    try cp -L $BUILD_freetype/objs/.libs/libfreetype.so $LIBS_PATH

}

# function called after all the compile have been done
function postbuild_freetype() {
	true
}

