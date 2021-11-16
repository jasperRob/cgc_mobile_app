#!/bin/bash
BUILD_NUMBER=`git rev-list --all|wc -l|xargs`

flutter packages get
flutter packages pub run flutter_launcher_icons:main


export FLUTTER_BUILD_NAME=3.0.0

flutter clean;
./build-docker.sh ;
docker push crowtech/cgc:latest;


