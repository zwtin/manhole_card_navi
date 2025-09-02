#!/bin/sh

cd  build/app/intermediates/flutter/release
mkdir obj
cp -a arm64-v8a obj
cp -a x86_64 obj
cp -a armeabi-v7a obj
cd obj
rm -f .DS_Store
zip -r symbols.zip .

