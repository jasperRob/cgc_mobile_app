#!/bin/bash
BUILD_NUMBER=`git rev-list --all|wc -l|xargs`

flutter clean;
flutter build apk --build-number $BUILD_NUMBER;
#flutter build appbundle --build-number $BUILD_NUMBER;
cd android
fastlane beta
cd ..


