#!/bin/bash

# IF YOU WANT TO BUILD ONLY, SET IT TO 0
# IF YOU WANT TO CONFIGURE + BUILD, THEN SET IT TO 1
WANT_TO_CONFIGURE_AND_BUILD=1


# DONOT CHANGE IT.
# If you set "WANT_TO_CONFIGURE_AND_BUILD" to "1", by default "WANT_TO_BUILD_ONLY" will be set to "1"
WANT_TO_BUILD_ONLY=$([ $WANT_TO_CONFIGURE_AND_BUILD -eq 0 ] && echo 1 || echo 0)




# Setup the Clang dependency ENV vars for pet (MANDATORY)
# "LLVM_FOR_PET_INSTALLATION_ROOT" set this to LLVM 16 build or installation path
LLVM_FOR_PET_INSTALLATION_ROOT=/path/to/your/llvm-16-src-build/installation

# If you already have another Clang version in your machine, and you are using another "clang" version, you need to keep this part.
LLVM_FOR_PET_LIB_PATH=$LLVM_FOR_PET_INSTALLATION_ROOT/lib
export LD_LIBRARY_PATH=$LLVM_FOR_PET_LIB_PATH${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}




# Name of the folder where you want to build
# This keeps the Pluto src tree much clean
BUILD_DIR="build/"


# Name of the folder, Where you want to install the bins
# By default, this will be passed as "../configure --prefix=pluto/installation ...."
# Name of the dir relative to pluto
INSTALLATION_DIR="installation/"



# Pluto Configure flags
# If you want to use cache, use "-C"
CONFIGURE_FLAGS="--enable-static"



# Set the absolute path for the pluto's "./configure --prefix=$INSTALL_PREFIX" option
# You can change it if you want.
INSTALL_PREFIX=$PWD/$INSTALLATION_DIR


# The LLVM build location
# Change according to your Clang location. Should be absolute path
CLANG_INSTALL_PATH=$LLVM_FOR_PET_INSTALLATION_ROOT





# Handle the build dir
remove_build_dir() {
    if [ -d $BUILD_DIR ]; then
        echo "$BUILD_DIR exists. Deleting..."
        rm -R $BUILD_DIR
        echo "$BUILD_DIR Creating..."
        mkdir -p $BUILD_DIR
    else
        echo "$BUILD_DIR directory does not exist. Creating $BUILD_DIR .."
        mkdir -p $BUILD_DIR
    fi
}


# Handle the install dir
remove_install_dir() {
    if [ -d $INSTALL_PREFIX ]; then
        echo "$INSTALL_PREFIX exists. Deleting..."
        rm -R $INSTALL_PREFIX
        echo "$INSTALL_PREFIX Creating..."
        mkdir -p $INSTALL_PREFIX
    else
        echo "$INSTALL_PREFIX directory does not exist. Creating $INSTALL_PREFIX .."
        mkdir -p $INSTALL_PREFIX
    fi
}



if [ $WANT_TO_BUILD_ONLY -eq 1 ]; then
    echo "You have set 'WANT_TO_BUILD_ONLY' as TRUE."
    echo "$BUILD_DIR will not be deleted."
    echo "$INSTALL_PREFIX will be deleted and created again."
    remove_install_dir
    # Change to build/ dir
    cd $BUILD_DIR
    make -j$(nproc)
    make install
else
    echo "You have set 'WANT_TO_BUILD_ONLY' as FALSE."
    echo "$BUILD_DIR will be deleted and created again."
    echo "$INSTALL_PREFIX will also be deleted and created again."
    remove_build_dir
    remove_install_dir
    # Change to build/ dir
    cd $BUILD_DIR
    ../configure --prefix=$INSTALL_PREFIX --with-clang-prefix=$CLANG_INSTALL_PATH $CONFIGURE_FLAGS
    make -j$(nproc)
    make install
fi


# Key commands that are running

# Change to build/ dir
# cd $BUILD_DIR

# Idea of configure command
# ../configure --prefix=$MY_EXTERNAL_SDD_WORK_DIR/compiler-projects/all-pluto-test/pluto-with-llvm-16/installation --with-clang-prefix=$MY_EXTERNAL_SDD_WORK_DIR/compiler-projects/llvm-src-build/installation --enable-static

# If you want to use cache
# ../configure -C --prefix=$INSTALL_PREFIX --with-clang-prefix=$CLANG_INSTALL_PATH $CONFIGURE_FLAGS

# ../configure --prefix=$INSTALL_PREFIX --with-clang-prefix=$CLANG_INSTALL_PATH $CONFIGURE_FLAGS

# make -j$(nproc)

# make install