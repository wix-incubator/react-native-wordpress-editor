/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    TouchableOpacity
} from 'react-native';
import { Navigation } from 'react-native-navigation';
import EditorScreen from './EditorScreen';
import WelcomeScreen from './WelcomeScreen';

Navigation.registerComponent('example.WelcomeScreen', () => WelcomeScreen);
Navigation.registerComponent('example.EditorScreen', () => EditorScreen);

Navigation.startSingleScreenApp({
  screen: {
    screen: 'example.WelcomeScreen',
    navigatorStyle: {
      navBarTextColor: '#ffffff',
      navBarButtonColor: '#ffffff',
      navBarBackgroundColor: '#00a0d2'
    },
    title: 'Welcome'
  }
});
