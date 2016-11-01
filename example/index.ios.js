/*
 * This file is part of the react-native-wordpress-editor project.
 *
 * Copyright (C) 2016 Wix.com Ltd
 *
 * react-native-wordpress-editor is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 2 of the License.
 *
 * react-native-wordpress-editor is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with react-native-wordpress-editor. If not, see <http://www.gnu.org/licenses/>
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
