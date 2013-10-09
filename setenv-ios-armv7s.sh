#!/bin/bash

################################################################
#  Copyright OpenSSL 2013
#  Contents licensed under the terms of the OpenSSL license
#  See http://www.openssl.org/source/license.html for details
################################################################

#
# setenv-ios-11-armv7s.sh
#

#################################

if [ ! -z "$OPENSSLDIR" ]; then
  echo "WARNING: OPENSSLDIR is not empty. Use IOS_INSTALLDIR instead"
fi

#################################

CROSS_ARCH="-armv7s"
CROSS_TYPE="iPhoneOS"

#################################

# Should be consistent with `xcode-select -print-path`
CROSS_DEVELOPER="/Applications/Xcode.app/Contents/Developer"

if [ ! -d "$CROSS_DEVELOPER" ]; then
  echo "ERROR: CROSS_DEVELOPER is not a valid path"
fi

#################################

# CROSS_TOP is the top of the development tools tree
# There's no usable compiler in here
export CROSS_TOP="$CROSS_DEVELOPER/Platforms/$CROSS_TYPE.platform/Developer"

if [ ! -d "$CROSS_TOP" ]; then
  echo "ERROR: CROSS_TOP is not a valid path"
fi

#################################

# CROSS_CHAIN is the location of the actual compiler tools
export CROSS_CHAIN="$CROSS_TOP"/usr/bin/

if [ ! -d "$CROSS_CHAIN" ]; then
  echo "ERROR: CROSS_CHAIN is not a valid path"
fi

#################################

# CROSS_SDK is the SDK version being used - adjust as appropriate
for i in 7.1 7.0 6.1 6.0 5.1 5.0 4.3 do
do
  if [ -d "$CROSS_DEVELOPER/Platforms/$CROSS_TYPE.platform//Developer/SDKs/$CROSS_TYPE$i.sdk" ]; then
    SDKVER=$i
    break
  fi
done

if [ -z "$SDKVER" ]; then
  echo "ERROR: SDKVER is not valid"
fi

#################################

export CROSS_SDK="$CROSS_TYPE""$SDKVER".sdk

#################################

# CROSS_SYSROOT is SYSROOT
export CROSS_SYSROOT="$CROSS_TOP/SDKs/$CROSS_SDK"

if [ ! -d "$CROSS_SYSROOT" ]; then
  echo "ERROR: CROSS_SYSROOT is not valid"
fi

#################################

#
# fips/sha/Makefile uses HOSTCC for building fips_standalone_sha1
#
export HOSTCC=/usr/bin/cc
export HOSTCFLAGS="-arch i686"

#################################

# CROSS_COMPILE is the prefix for the tools - in this case the scripts
# which invoke the tools with the correct options for 'fat' binary handling
export CROSS_COMPILE="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/"

if [ ! -d "$CROSS_COMPILE" ]; then
  echo "ERROR: CROSS_COMPILE is not valid"
fi

#################################

#
# these remain to be cleaned up ... 
#

export IOS_TARGET=darwin-iphoneos-cross
export IOS_INSTALLDIR=/usr/local/ssl/ios

#################################

#
# definition for uname output for cross-compilation
#
MACHINE=`echo "$CROSS_ARCH" | sed -e 's/^-//'`
SYSTEM="iphoneos"
BUILD="build"
RELEASE="$SDKVER"

export MACHINE
export SYSTEM
export BUILD
export RELEASE

#################################

export PATH="$CROSS_CHAIN":$PATH

#################################

# for iOS we have not plugged in ASM or SHLIB support so we disable
# those options for now
export CONFIG_OPTIONS="no-asm no-shared --openssldir=$IOS_INSTALLDIR"

echo "$CROSS_TYPE, $CROSS_ARCH"
echo "CONFIG_OPTIONS=$CONFIG_OPTIONS"
