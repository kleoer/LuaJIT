LUAJIT=.
DEVDIR=`xcode-select -print-path`
IOSSDKVER=14.1
IOSDIR=$DEVDIR/Platforms
IOSBIN=$DEVDIR/Toolchains/XcodeDefault.xctoolchain/usr/bin/
IOSBIN=/usr/bin/

BUILD_DIR=$LUAJIT/.build

PUBLIC_HEADER_DIR="./src"
LIBRARY_DIR="./lib"

rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR
rm -rf $LIBRARY_DIR
mkdir -p $LIBRARY_DIR
rm *.a 1>/dev/null 2>/dev/null


ISDKF="-arch x86_64 -isysroot $IOSDIR/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk -miphoneos-version-min=8.0"
make -j -C $LUAJIT HOST_CC="clang -m64" CROSS=$IOSBIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" clean
make -j -C $LUAJIT HOST_CC="clang -m64" CROSS=$IOSBIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" amalg
mv $LUAJIT/src/libluajit.a $BUILD_DIR/libluajitx86_64.a

ISDKF="-arch arm64 -isysroot $IOSDIR/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk -miphoneos-version-min=8.0"
make -j -C $LUAJIT HOST_CC="xcrun clang -m64 -arch x86_64" CROSS=$IOSBIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" clean
make -j -C $LUAJIT HOST_CC="xcrun clang -m64 -arch x86_64" CROSS=$IOSBIN TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS XCFLAGS="-DLJ_NO_SYSTEM=1" amalg
mv $LUAJIT/src/libluajit.a $BUILD_DIR/libluajitA64.a

LIBRARY_OPTIONS=""
for lib in `ls ${BUILD_DIR}/libluajit*.a`
do
    LIBRARY_OPTIONS="${LIBRARY_OPTIONS} -library ${lib} -headers ${PUBLIC_HEADER_DIR}"
done

${IOSBIN}/xcodebuild -create-xcframework ${LIBRARY_OPTIONS} -output ${LIBRARY_DIR}/libluajit.xcframework 2> /dev/null

