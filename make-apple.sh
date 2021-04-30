LUAJIT=.
DEVDIR=`xcode-select -print-path`
PLATFORMS_DIR=$DEVDIR/Platforms
XCTOOL_BIN=/usr/bin/

BUILD_DIR="${LUAJIT}/.build"

PUBLIC_HEADER_DIR="${LUAJIT}/src"
LIBRARY_DIR="${LUAJIT}/lib"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
rm -rf $LIBRARY_DIR
mkdir -p $LIBRARY_DIR
rm *.a 1>/dev/null 2>/dev/null


ISDKF="-arch x86_64 -isysroot $PLATFORMS_DIR/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk -miphoneos-version-min=9.0"
make -j -C $LUAJIT HOST_CC="clang -m64" CROSS=$XCTOOL_BIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" clean
make -j -C $LUAJIT HOST_CC="clang -m64" CROSS=$XCTOOL_BIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" amalg
mv $LUAJIT/src/libluajit.a $BUILD_DIR/libluajit-ios-x86_64-simulator.a

ISDKF="-arch arm64 -isysroot $PLATFORMS_DIR/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -miphoneos-version-min=9.0"
make -j -C $LUAJIT HOST_CC="xcrun clang -m64 -arch x86_64" CROSS=$XCTOOL_BIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" clean
make -j -C $LUAJIT HOST_CC="xcrun clang -m64 -arch x86_64" CROSS=$XCTOOL_BIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" amalg
mv $LUAJIT/src/libluajit.a $BUILD_DIR/libluajit-ios-arm64.a

ISDKF="-arch x86_64 -isysroot $PLATFORMS_DIR/MacOSX.platform/Developer/SDKs/MacOSX.sdk -mmacosx-version-min=10.12"
make -j -C $LUAJIT HOST_CC="xcrun clang -m64 -arch x86_64" CROSS=$XCTOOL_BIN TARGET_FLAGS="$ISDKF" TARGET_SYS=Darwin MACOSX_DEPLOYMENT_TARGET=10.15 XCFLAGS="-DLJ_NO_SYSTEM=1" clean
make -j -C $LUAJIT HOST_CC="xcrun clang -m64 -arch x86_64" CROSS=$XCTOOL_BIN TARGET_FLAGS="$ISDKF" TARGET_SYS=Darwin MACOSX_DEPLOYMENT_TARGET=10.15 XCFLAGS="-DLJ_NO_SYSTEM=1" amalg
mv $LUAJIT/src/libluajit.a $BUILD_DIR/libluajit-macos-x86_64.a

ISDKF="-arch x86_64 -isysroot $PLATFORMS_DIR/AppleTVSimulator.platform/Developer/SDKs/AppleTVSimulator.sdk"
make -j -C $LUAJIT HOST_CC="clang -m64 -arch x86_64" CROSS=$XCTOOL_BIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" clean
make -j -C $LUAJIT HOST_CC="clang -m64 -arch x86_64" CROSS=$XCTOOL_BIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" amalg
mv $LUAJIT/src/libluajit.a $BUILD_DIR/libluajit-tvos-x86_64-simulator.a

ISDKF="-arch arm64 -isysroot $PLATFORMS_DIR/AppleTVOS.platform/Developer/SDKs/AppleTVOS.sdk -mappletvos-version-min=9.0"
make -j -C $LUAJIT HOST_CC="xcrun clang -m64" CROSS=$XCTOOL_BIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" clean
make -j -C $LUAJIT HOST_CC="xcrun clang -m64" CROSS=$XCTOOL_BIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" amalg
mv $LUAJIT/src/libluajit.a $BUILD_DIR/libluajit-tvos-arm64.a

LIBRARY_OPTIONS=""
for lib in `ls ${BUILD_DIR}/libluajit*.a`
do
    LIBRARY_OPTIONS="${LIBRARY_OPTIONS} -library ${lib} -headers ${PUBLIC_HEADER_DIR}"
done

${XCTOOL_BIN}/xcodebuild -create-xcframework ${LIBRARY_OPTIONS} -output ${LIBRARY_DIR}/libluajit.xcframework 2> /dev/null

