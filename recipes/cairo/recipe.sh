#!/bin/bash


#http://lists.cairographics.org/archives/cairo/2012-January/022669.html
VERSION_cairo=${VERSION_cairo:-1.10.0}
DEPS_cairo=(sdl python)
URL_cairo=#http://cairographics.org/releases/py2cairo-1.10.0.tar.bz2
#URL_cairo=git clone --recursive git@github.com:anoek/android-cairo.git
#URL_cairo=https://github.com/anoek/android-cairo/archive/master.zip
#URL_cairo=https://code.google.com/p/cairo4android/downloads/detail?name=cairo4android-src.zip&can=2&q=
#URL_cairo=https://code.google.com/p/cairo4android/downloads/detail?name=cairo4android-src.zip
#MD5_cairo=4ba105e2d8535496fd633889396b20b7
BUILD_cairo=$BUILD_PATH/cairo/$(get_directory $URL_cairo)
RECIPE_cairo=$RECIPES_PATH/cairo

# function called for preparing source code if needed
# (you can apply patch etc here.)

#http://stackoverflow.com/questions/791959/download-a-specific-tag-with-git
function prebuild_cairo() {
    git clone git://git.cairographics.org/git/py2cairo $BUILD_cairo/pycairo
    git clone --recursive git@github.com:olymk2/android-cairo.git $BUILD_cairo/cairo
    #~ git clone --recursive git@github.com:anoek/android-cairo.git /home/oly/repos/python-for-android/build/cairo
    true
}

#~ function shouldbuild_cairo() {
    #~ if [ -d "$SITEPACKAGES_PATH/cairo" ]; then
        #~ DO_BUILD=0
    #~ fi
#~ }

function build_cairo() {
    cd $SRC_PATH/jni

    push_arm
    #export NDK_PROJECT_PATH=$BUILD_cairo
    echo 'ndk build cairo'
    try ndk-build NDK_DEBUG=1 V=1 #-C $BUILD_cairo
    echo 'ndk build finish cairo'
    pop_arm

    echo '######## build cario' 
    cd $BUILD_cairo
    echo $BUILD_cairo
    pwd
    push_arm
    
    echo '######## pycairo'
    echo $PKG_CONFIG_PATH
    export CFLAGS="$CFLAGS -I$BUILD_PATH/python-install/include/python2.7 -I$BUILD_PATH/python-install/include/python2.7"
    export CPPFLAGS="$CPPFLAGS -I$BUILD_PATH/python-install/include/python2.7"
    #export PKG_CONFIG_PATH=
    #export LDSHARED=$LIBLINK
    #export PYTHONPATH=$BUILD_PATH/python-install/lib/python2.7/site-packages
    #export PYTHONPATH=$BUILD_cairo/Lib/site-packages
    #export PYTHON=/home/oly/repos/oly/python-for-android/build/python/Python-2.7.2/

    #python ./waf configure
    try autoreconf -f -i -Wall,no-obsolete



    echo '########configure'
    echo $BUILD_PATH/python-install
    echo ./configure --build=i686-pc-linux-gnu --host=arm-linux-eabi --prefix="$BUILD_PATH/python-install" --enable-shared
    try ./configure --build=i686-pc-linux-gnu --host=arm-linux-eabi --without-plugins --prefix=$BUILD_PATH/python-install/include/python2.7 --enable-shared
    echo '########make'
    try make
    pop_arm



    try cp -a $SRC_PATH/libs/$ARCH/*.so $LIBS_PATH
}

# function called after all the compile have been done
function postbuild_cairo() {
    true
}
