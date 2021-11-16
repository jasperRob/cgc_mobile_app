# Compact-Golf-Course Mobile Application

An App for the CGC system built using Flutter for easy support of both android and ios devices.

&nbsp;

### XCode Support Files

To test on newer versions of IOS, you must ensure all developer files are included in XCode. 

You can clone the device suport repository: https://github.com/iGhibli/iOS-DeviceSupport.git, and use the deploy script to do so.

&nbsp;

### AR Virtual Tee

The plan is to implement an Augmented Realityb Virtual Tee for both Android and IOS platforms. These will require seperate AR plugins:

- ARKit: AR plugin for IOS
- ACore: AR plugin for Android

As of the moment, only IOS Virtual Tee is supported.

&nbsp;

## To Compile

```sh
flutter clean
flutter build ipa --release
```

Then use the XCode to open `build/ios/Runner.xarchive` and distribute

