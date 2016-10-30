# React Native WordPress Rich Text Editor

React Native Wrapper for [WordPress Rich Text Editor](https://github.com/wordpress-mobile/WordPress-Editor-iOS). The WordPress-Editor is the text editor used in the official WordPress mobile [apps](https://github.com/wordpress-mobile) to create and edit pages & posts. In short it's a simple, straightforward way to visually edit HTML.

> Current experimental implementation is for iOS only.

<br>
<p align="left">
  <img src="http://i.imgur.com/nFDjKO5.png" width="350"/>
</p>

### Dependencies

* [react-native-navigation](https://github.com/wix/react-native-navigation) - native navigation library for React Native (required to natively display the editor within RN)

### How is integration possible?

It isn't trivial to intergrate the WordPress editor with React Native because it is exposed in native code as a [`UIViewController`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/) and not a [`UIView`](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIView_Class/). React Native only has internal support for integrating native `UIViews` by [wrapping them](https://facebook.github.io/react-native/docs/native-components-ios.html) as React components.

In order to integrate a `UIViewController` with RN, we have to turn to the library [react-native-navigation](https://github.com/wix/react-native-navigation) which fully supports native app skeletons with View Controllers. If you're interested in how it's achieved, take a look at the following [internal dependency](https://github.com/wix/react-native-controllers) of this awesome library.

### Installation

* Make sure your project relies on React Native >= 0.25

* Make sure your project uses **react-native-navigation** and that you've followed the **Installation** instructions [there](https://github.com/wix/react-native-navigation)

* In your RN project root run:<br>`npm install react-native-wordpress-editor --save`

* Open your Xcode project and drag the folder `node_modules/react-native-wordpress-editor/ios` into your project

### Usage

#### For a fully working example look [here](example)

First, create a placeholder screen for the editor. The main purpose of this screen is to handle navigation events. See an example [here](https://github.com/wix/react-native-wordpress-editor/blob/master/example/EditorScreen.js).

> Note: Make sure your screen component has been registered with `Navigation.registerComponent` like all react-native-navigation screens need to be, [example](https://github.com/wix/react-native-wordpress-editor/blob/master/example/index.ios.js).

Now, to display your screen, from within one of your other app screens, push the editor:

```js
this.props.navigator.push({
  screen: 'example.EditorScreen',
  title: 'Preview',
  passProps: {
    externalNativeScreenClass: 'RNWordPressEditorViewController',
    externalNativeScreenProps: {
      // the post to open in the editor, leave empty for no post
      post: {
        // title of the post
        title: 'Hello WorldPress',
        // html body of the post
        body: 'cool HTML body <br><br> <img src="https://www.wpshrug.com/wp-content/uploads/2016/05/wordpress-winning-meme.jpg" />'
      },
      // if no post shown, these placeholders will appear in the relevant fields
      placeHolders: {
        title: 'title',
        body: 'body'
      }
    }
  }
});
```

### API Reference

Once the editor screen is displayed, you can communicate with it using a JS interface.

```js
import EditorManager from 'react-native-wordpress-editor';
```

* **`EditorManager.setEditingState(editing: boolean)`**
<br>Switch between editing and preview modes (accepts a boolean).

* **`EditorManager.resetStateToInitial()`**
<br>Reset to the initial state right after the screen was pushed (with original props).

* **`EditorManager.isPostChanged(): Promise<boolean>`**
<br>Returns a promise of a boolean (since it's async) whether the state is still the initial one.

* **`EditorManager.getPostData(): Promise<{title: string, body: string}>`**
<br>Returns a promise of a simple object holding the `title` and HTML `body` of the post.

* **`EditorManager.addImages(images: Array<{url: string}>)`**
<br>Adds images at the current cursor location in the editor, takes an array of simple objects with the `url` of each image.

### License

React Native WordPress Rich Text Editor is available under the GPL license. See the [LICENSE](https://raw.githubusercontent.com/wix/react-native-wordpress-editor/master/LICENSE) file for more info.
