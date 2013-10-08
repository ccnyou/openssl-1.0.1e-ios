#! /bin/sh

# Place setenv.ios.sh and build-all-for-ios.sh next to the makefile.
# Run ./build-all-for-ios.sh

################################################################
# First, fix things
echo "****************************************"

make clean && make dclean

OLD_LANG=$LANG
unset LANG

sed -i "" 's|\"iphoneos-cross\"\,\"llvm-gcc\:-O3|\"iphoneos-cross\"\,\"clang\:-Os|g' Configure
sed -i "" 's/CC= cc/CC= clang/g' Makefile.org
sed -i "" 's/CFLAG= -O/CFLAG= -Os/g' Makefile.org
sed -i "" 's/MAKEDEPPROG=makedepend/MAKEDEPPROG=$(CC) -M/g' Makefile.org

export LANG=$OLD_LANG
export CC=clang
export IOS_INSTALLDIR="/usr/local/ssl/ios"
unset OPENSSLDIR

################################################################
# Second, build i386
echo "****************************************"
THIS_ARCH=i386
. ./setenv-ios-$THIS_ARCH.sh
make clean && make dclean
./config -no-sslv2 -no-sslv3 -no-hw -no-engine --openssldir=$IOS_INSTALLDIR
make depend
make all
mkdir $THIS_ARCH
\cp ./libcrypto.a $THIS_ARCH/libcrypto.a
\cp ./libssl.a $THIS_ARCH/libssl.a

################################################################
# Third, build ARMv7
echo "****************************************"
THIS_ARCH=armv7
. ./setenv-ios-$THIS_ARCH.sh
make clean && make dclean
./config -no-sslv2 -no-sslv3 -no-hw -no-engine --openssldir=$IOS_INSTALLDIR
make depend
make all
mkdir $THIS_ARCH
\cp ./libcrypto.a $THIS_ARCH/libcrypto.a
\cp ./libssl.a $THIS_ARCH/libssl.a

################################################################
# Fourth, build ARMv7s
echo "****************************************"
THIS_ARCH=armv7s
. ./setenv-ios-$THIS_ARCH.sh
make clean && make dclean
./config -no-sslv2 -no-sslv3 -no-hw -no-engine --openssldir=$IOS_INSTALLDIR
make depend
make all
mkdir $THIS_ARCH
\cp ./libcrypto.a $THIS_ARCH/libcrypto.a
\cp ./libssl.a $THIS_ARCH/libssl.a

################################################################
# Fifth, build ARM64
echo "****************************************"
THIS_ARCH=arm64
. ./setenv-ios-$THIS_ARCH.sh
make clean && make dclean
./config -no-sslv2 -no-sslv3 -no-hw -no-engine --openssldir=$IOS_INSTALLDIR
make depend
make all
mkdir $THIS_ARCH
\cp ./libcrypto.a $THIS_ARCH/libcrypto.a
\cp ./libssl.a $THIS_ARCH/libssl.a

################################################################
# Sixth, create the fat library
echo "****************************************"
lipo -create armv7/libcrypto.a armv7s/libcrypto.a arm64/libcrypto.a i386/libcrypto.a -output ./libcrypto.a
lipo -create armv7/libssl.a armv7s/libssl.a arm64/libssl.a i386/libssl.a -output ./libssl.a

################################################################
# Sixth, verify the three architectures are present
echo "****************************************"
xcrun -sdk iphoneos lipo -info libcrypto.a
xcrun -sdk iphoneos lipo -info libssl.a

################################################################
# Seventh, install the library
echo "****************************************"
sudo -E make install
