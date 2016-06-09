# React Native WordPress Editor

React Native Wrapper for [WordPress Rich Text Editor](https://github.com/wordpress-mobile/WordPress-Editor-iOS). The WordPress-Editor is the text editor used in the official WordPress mobile [apps](https://github.com/wordpress-mobile) to create and edit pages & posts. In short it's a simple, straightforward way to visually edit HTML.

> Current experimental implementation is for iOS only.

### Dependencies

* [native code for the original editor](https://github.com/wordpress-mobile/WordPress-Editor-iOS) (a git submodule) - actually taken from this [leaner fork](https://github.com/wix/WordPress-Editor-iOS)

* [react-native-navigation](https://github.com/wix/react-native-navigation) - native navigation library for React Native (required to natively display the editor within RN)

### How is integration possible?

It isn't trivial to intergrate the WordPress editor with React Native because it is exposed in native code as a [`UIViewController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/) and not a [`UIView`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIView_Class/). React Native only has internal support for integrating native `UIViews` by [wrapping them](https://facebook.github.io/react-native/docs/native-components-ios.html) as React components.

In order to integrate a `UIViewController` with RN, we have to turn to the library [react-native-navigation](https://github.com/wix/react-native-navigation) which fully supports native app skeletons with View Controllers. If you're interested in how it's achieved, take a look at the following [internal dependency](https://github.com/wix/react-native-controllers) of this awesome library.

### Installation

* Make sure your project uses **react-native-navigation** and that you've followed the **Installation** instructions [there](https://github.com/wix/react-native-navigation)

* In your RN project root run:<br>`npm install react-native-wordpress-editor --save`

* Open your Xcode project and drag the folder `node_modules/react-native-wordpress-editor/ios` into your project

### Usage

