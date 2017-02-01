#!/bin/bash
set -e

export TOOL_DIR=$PWD/toolchain
export PATH=$TOOL_DIR/bin:$TOOL_DIR/local/bin:$TOOL_DIR/local/libexec:$PATH

rm -rf toolchain

cd core/dtrace
rm -rf obj sym dst
mkdir obj sym dst
xcodebuild install -target ctfconvert -target ctfdump -target ctfmerge ARCHS="x86_64" SRCROOT=$PWD OBJROOT=$PWD/obj SYMROOT=$PWD/sym DSTROOT=$PWD/dst
cp -r $PWD/dst/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/* $TOOL_DIR/

cd ../AvailabilityVersions
rm -rf dst
mkdir dst
make install SRCROOT=$PWD DSTROOT=$PWD/dst
cp -r $PWD/dst/* $TOOL_DIR/

cd ../Libsystem
rm -rf obj sym dst
xcodebuild installhdrs -sdk macosx ARCHS='x86_64 i386' SRCROOT=$PWD OBJROOT=$PWD/obj SYMROOT=$PWD/sym DSTROOT=$PWD/dst
cp -r $PWD/dst/usr/* $TOOL_DIR/

cd ../xnu
make SDKROOT=macosx ARCH_CONFIGS=X86_64 KERNEL_CONFIGS=RELEASE
mkdir -p BUILD.hdrs/obj BUILD.hdrs/sym BUILD.hdrs/dst
make installhdrs SDKROOT=macosx ARCH_CONFIGS=X86_64 SRCROOT=$PWD OBJROOT=$PWD/BUILD.hdrs/obj SYMROOT=$PWD/BUILD.hdrs/sym DSTROOT=$PWD/BUILD.hdrs/dst
sudo xcodebuild installhdrs -project libsyscall/Libsyscall.xcodeproj -sdk macosx ARCHS='x86_64 i386' SRCROOT=$PWD/libsyscall OBJROOT=$PWD/BUILD.hdrs/obj SYMROOT=$PWD/BUILD.hdrs/sym DSTROOT=$PWD/BUILD.hdrs/dst
cp -r BUILD.hdrs/dst/* $TOOL_DIR/