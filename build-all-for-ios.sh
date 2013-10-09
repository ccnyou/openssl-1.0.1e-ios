#! /bin/sh

################################################################
#  Copyright OpenSSL 2013
#  Contents licensed under the terms of the OpenSSL license
#  See http://www.openssl.org/source/license.html for details
################################################################

# Place setenv.ios-<arch>.sh and build-all-for-ios.sh next to the makefile.
# Run ./build-all-for-ios.sh

################################################################
# First, fix things
echo "****************************************"

OLD_LANG=$LANG
unset LANG

sed -i "" 's|\"iphoneos-cross\"\,\"llvm-gcc\:-O3|\"iphoneos-cross\"\,\"clang\:-Os|g' Configure
sed -i "" 's/CC= cc/CC= clang/g' Makefile.org
sed -i "" 's/CFLAG= -O/CFLAG= -Os/g' Makefile.org
sed -i "" 's/MAKEDEPPROG=makedepend/MAKEDEPPROG=$(CC) -M/g' Makefile.org

export LANG=$OLD_LANG
export CC=clang
export IOS_INSTALLDIR="/usr/local/ssl/ios-6"
unset OPENSSLDIR

################################################################
# Second, build i386
echo "****************************************"
THIS_ARCH=i386
unset CROSS_ARCH

. ./setenv-ios-$THIS_ARCH.sh
./config -no-ssl2 -no-ssl3 -no-asm -no-shared -no-hw -no-engine --openssldir=$IOS_INSTALLDIR
make clean 2>&1>/dev/null && make all
mkdir $THIS_ARCH
\cp ./libcrypto.a $THIS_ARCH/libcrypto.a
\cp ./libssl.a $THIS_ARCH/libssl.a

################################################################
# Third, build ARMv7
echo "****************************************"
THIS_ARCH=armv7
unset CROSS_ARCH

. ./setenv-ios-$THIS_ARCH.sh
./config -no-ssl2 -no-ssl3 -no-asm -no-shared -no-hw -no-engine --openssldir=$IOS_INSTALLDIR
make clean 2>&1>/dev/null && make all
mkdir $THIS_ARCH
\cp ./libcrypto.a $THIS_ARCH/libcrypto.a
\cp ./libssl.a $THIS_ARCH/libssl.a

################################################################
# Fourth, build ARMv7s
echo "****************************************"
THIS_ARCH=armv7s
unset CROSS_ARCH

. ./setenv-ios-$THIS_ARCH.sh
./config -no-ssl2 -no-ssl3 -no-asm -no-shared -no-hw -no-engine --openssldir=$IOS_INSTALLDIR
make clean 2>&1>/dev/null && make all
mkdir $THIS_ARCH
\cp ./libcrypto.a $THIS_ARCH/libcrypto.a
\cp ./libssl.a $THIS_ARCH/libssl.a

################################################################
# Fifth, build ARM64
#echo "****************************************"
THIS_ARCH=arm64
unset CROSS_ARCH

. ./setenv-ios-$THIS_ARCH.sh
./config -no-ssl2 -no-ssl3 -no-asm -no-shared -no-hw -no-engine --openssldir=$IOS_INSTALLDIR
make clean 2>&1>/dev/null && make all
mkdir $THIS_ARCH
\cp ./libcrypto.a $THIS_ARCH/libcrypto.a
\cp ./libssl.a $THIS_ARCH/libssl.a

################################################################
# Sixth, create the fat library
echo "****************************************"
lipo -create armv7/libcrypto.a armv7s/libcrypto.a arm64/libcrypto.a i386/libcrypto.a -output ./libcrypto.a
lipo -create armv7/libssl.a armv7s/libssl.a arm64/libssl.a i386/libssl.a -output ./libssl.a

################################################################
# Seventh, verify the three architectures are present
echo "****************************************"
xcrun -sdk iphoneos lipo -info libcrypto.a
xcrun -sdk iphoneos lipo -info libssl.a

################################################################
# Eight, install the library
echo "****************************************"

read -p "Press [ENTER] to install the library or [CTRL]+C to exit"

sudo -E make install

################################################################
# Ninth, cleanup the install
echo "****************************************"
sudo rm -rf "$IOS_INSTALLDIR/openssl.cnf"
sudo rm -rf "$IOS_INSTALLDIR/bin"
sudo rm -rf "$IOS_INSTALLDIR/certs"
sudo rm -rf "$IOS_INSTALLDIR/man"
sudo rm -rf "$IOS_INSTALLDIR/misc"
sudo rm -rf "$IOS_INSTALLDIR/private"

################################################################
# Tenth, build the tarball
mkdir openssl-ios
cp -R "$IOS_INSTALLDIR/include" openssl-ios/
cp -R "$IOS_INSTALLDIR/lib" openssl-ios/
tar czf openssl-1.0.1e-ios-6.1.tar.gz openssl-ios/

################################################################
# Eleventh, cleanup
make clean 2>&1>/dev/null && make dclean 2>&1>/dev/null

\rm -rf openssl-ios/
\rm -rf i386/
\rm -rf armv7/
\rm -rf armv7s/
\rm -rf arm64/
