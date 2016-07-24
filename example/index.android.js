/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity
} from 'react-native';
import { Navigation } from 'react-native-navigation';
import EditorScreen from './EditorScreen';
import WelcomeScreen from './WelcomeScreen';

class example extends Component {
  render() {
    return (
        <View style={styles.container}>
          <Text style={styles.welcome}>
            Welcome to React Native!
          </Text>
          <Text style={styles.instructions}>
            To get started, edit index.android.js
          </Text>
          <Text style={styles.instructions}>
            Shake or press menu button for dev menu
          </Text>
        </View>
    );
  }
}


Navigation.registerComponent('example', () => example);



Navigation.startSingleScreenApp({
  screen: {
    screen: 'example',
    navigatorStyle: {
      navBarTextColor: '#ffffff',
      navBarButtonColor: '#ffffff',
      navBarBackgroundColor: '#00a0d2'
    },
    title: 'ANDROID!'
  }
});



const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
});

