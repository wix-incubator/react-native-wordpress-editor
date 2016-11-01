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
  StyleSheet,
  Text,
  View,
  TouchableOpacity, Platform
} from 'react-native';

export default class WelcomeScreen extends Component {
  onPress() {
    if(Platform.OS === 'ios') {
      this.props.navigator.push({
        screen: 'example.EditorScreen',
        title: 'Preview',
        passProps: {
          externalNativeScreenClass: 'RNWordPressEditorViewController',
          externalNativeScreenProps: {
            post: {
              title: 'Hello WorldPress',
              body: 'cool HTML body <br><br> <img src="https://www.wpshrug.com/wp-content/uploads/2016/05/wordpress-winning-meme.jpg" />'
            },
            placeHolders: {title: 'title', body: 'body'}
          }
        }
      });
    } else {
      this.props.navigator.push({
        screen: 'example.EditorScreen',
        title: 'Preview',
        passProps: {
          post: {
            title: 'Hello WorldPress',
            body: 'cool HTML body <br><br> <img src="https://www.wpshrug.com/wp-content/uploads/2016/05/wordpress-winning-meme.jpg" />'
          },
          placeHolders: {title: 'title', body: 'body'}
        },
        fragmentCreatorClassName: 'com.wix.RNWordpressEditor.EditorManager'
      });
    }
  }

  render() {
    return (
      <View style={styles.container}>
        <TouchableOpacity onPress={this.onPress.bind(this)}>
          <Text style={{color: 'blue', fontSize: 18}}>
            Push WordPress Editor!
          </Text>
        </TouchableOpacity>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  }
});