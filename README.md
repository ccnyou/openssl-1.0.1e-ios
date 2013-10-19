openssl-1.0.1e-ios
==================

OpenSSL 1.0.1e built for ARMv7, ARMv7s, ARM64 and i386 simulator. The libraries were built using the iOS 7.0 SDK. The archive includes one common set of headers, one fat libcrypto.a and one fat libssl.a with the four architectures.

If you only want to include, compile, and link, then only download openssl-1.0.1e-ios-7.0.tar.gz. It has everything you need for an Xcode or command line project. Untar with `tar xzf` and place the directory in a convenient location. `/usr/local/ssl/ios/` is a good location since it is world readable and write protected.

Note: while the OpenSSL library is mutli-arch, Xcode cannot currently create iOS 6 mutli-arch apps when the app contains both 32-bit and 64-bit components. For example, ARMv7 is 32-bit and ARM64 is 64-bit, so Xcode will not be able to create the fat binary. This is an Apple/Xcode limitation, and Apple claims it will be fixed soon. For details, see http://lists.apple.com/archives/xcode-users/2013/Oct/msg00074.html.

The libraries were configured and compiled without SSLv2, SSLv3, Assembly, Shared Objects, Hardware, and Engines. See `build-all-for-ios.sh` for the configure options used. Lack of SSLv3 is not hardship because TLSv1 is ubiquitous (https://en.wikipedia.org/wiki/Transport_Layer_Security).

The two images included in this collection show you how to configure an Xcode project using the files in the tarball. The images are provided since you probably have a good idea of what you are doing.

The additional files provided in the set are used to update the standard OpenSSL 1.0.1e distribution and build the fat libcrypto.a and libssl.a. Place them in the same directory as OpenSSL source files (specifically, next to the top level Makefile), and then run `./build-all-for-ios.sh`. Before running the script, verify `IOS_INSTALLDIR` is set properly in the script. If you don't want to use `/usr/local/ssl/ios/`, then change it. If you don't care about building libcrypto.a and libssl.a yourself, then ignore the additional files.

Note: these prebuilt libraries are not FIPS Capable. If you need the FIPS Capable library, then you will have to build them yourself following the OpenSSL FIPS User Guide or contact the OpenSSL Foundation for assistance. You can find the OpenSSL FIPS User Guide at http://openssl.org/docs/fips/UserGuide-2.0.pdf.

Copyright OpenSSL 2013. Contents licensed under the terms of the OpenSSL license. See http://www.openssl.org/source/license.html for details
