#!/bin/bash
DEPLOY_MODE="TRUE"
BUILD_NUMBER=`git rev-list --all|wc -l|xargs`
echo $BUILD_NUMBER

#export FLUTTER_BUILD_NAME=

flutter clean;
echo "Build number is ${BUILD_NUMBER}"
flutter build ios  --dart-define=DEPLOY_MODE=${DEPLOY_MODE};
#flutter build ios --build-number $BUILD_NUMBER;
cd ios
fastlane internal
cd ..

