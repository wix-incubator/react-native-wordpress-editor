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