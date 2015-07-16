#!/bin/bash

VERSION_harfbuzz=${VERSION_harfbuzz:-2.5.5}
URL_harfbuzz=http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.40.tar.bz2
MD5_harfbuzz=0e27e531f4c4acff601ebff0957755c2
BUILD_harfbuzz=$BUILD_PATH/harfbuzz/$(get_directory $URL_harfbuzz)
RECIPE_harfbuzz=$RECIPES_PATH/harfbuzz

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_harfbuzz() {
    true
}

function shouldbuild_harfbuzz() {
    if [ -f "$BUILD_harfbuzz/src/.libs/libharfbuzz.so" ]; then
        DO_BUILD=0
    fi
}

function build_harfbuzz() {
    cd $BUILD_harfbuzz
    push_arm
    export CFLAGS="$CFLAGS -I$BUILD_freetype/include"
    export LDFLAGS="$LDFLAGS -L$LIBS_PATH"
    #export LDSHARED="$LIBLINK"
    #try ./autogen.sh
    try ./configure --build=i686-pc-linux-gnu  --without-icu --host=arm-linux-androideabi --prefix="$BUILD_PATH/python-install" --without-freetype --without-glib  --enable-shared
    try make -j5
    pop_arm
    #try cp -L $BUILD_harfbuzz/src/.libs/libharfbuzz.so $LIBS_PATH
}
#http://stackoverflow.com/questions/6666805/what-does-each-column-of-objdumps-symbol-table-mean

# function called after all the compile have been done
function postbuild_harfbuzz() {
    if [ -f "$BUILD_freetype/objs/.libs/libfreetype.so" ]; then
        echo "freetype found rebuilding harfbuzz with freetype support";
        cd $BUILD_harfbuzz
        push_arm
        export CFLAGS="$CFLAGS -I$BUILD_freetype/include"
        export LDFLAGS="$LDFLAGS -L$LIBS_PATH -L$BUILD_freetype/objs/.libs/"
        export LDSHARED="$LIBLINK"
        try ./configure --build=i686-pc-linux-gnu  --without-icu --host=arm-linux-androideabi --prefix="$BUILD_PATH/python-install" --with-freetype --without-glib  --enable-shared
        try make -j5 -nostdinc 
        pop_arm
        echo $LIBS_PATH
        ls $BUILD_harfbuzz/src/.libs
        try cp -L $BUILD_harfbuzz/src/.libs/libharfbuzz.so $LIBS_PATH

        cd $BUILD_freetype
        push_arm
        export HARFBUZZ_CFLAGS="-I$BUILD_harfbuzz/src/"
        export HARFBUZZ_LIBS="-L$BUILD_harfbuzz/src/.libs/"
        try ./configure --host=arm-linux-androideabi --prefix=$BUILD_freetype --without-zlib --with-png=no --with-harfbuzz=yes --enable-shared
    
        #-nostdinc is breaking but we probably want this
        try make -j5
        pop_arm

        try cp $BUILD_freetype/objs/.libs/libfreetype.so $LIBS_PATH


    fi
}

