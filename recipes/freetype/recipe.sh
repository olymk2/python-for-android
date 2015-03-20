#!/bin/bash

VERSION_freetype=${VERSION_freetype:-2.5.5}
#DEPS_freetype=(python)
URL_freetype=http://download.savannah.gnu.org/releases/freetype/freetype-2.5.5.tar.gz
#MD5_freetype=4ba105e2d8535496fd633889396b20b7
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

	#~ export CC="$CC -I$BUILD_libfreetype/include"
	#~ export LDFLAGS="$LDFLAGS -L$LIBS_PATH"
	#~ export LDSHARED="$LIBLINK"

    #export LDSHARED="$LIBLINK"
    # http://en.wikibooks.org/wiki/OpenGL_Programming/Installation/Android_NDK#FreeType


    #try sh autogen.sh
	try ./configure --build=i686-pc-linux-gnu --host=arm-linux-androideabi --prefix="$BUILD_PATH/python-install" --without-zlib --with-png=no --without-harfbuzz --enable-shared
	#try ./configure --build=i686-pc-linux-gnu --host=arm-eabi OPT=$OFLAG --enable-shared --disable-toolbox-glue --disable-framework --without-zlib --with-png=no
	try make -j5
	#try make -k CROSS_COMPILE_TARGET=yes INSTSONAME=libfreetype.so#-j4
	pop_arm
    echo 'finished'
    try cp -L $BUILD_freetype/objs/.libs/libfreetype.so $LIBS_PATH/libfreetype.so.6
    try cp -L $BUILD_freetype/objs/.libs/libfreetype.so $LIBS_PATH

}

# function called after all the compile have been done
function postbuild_freetype() {
	true
}

