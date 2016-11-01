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
import {NativeAppEventEmitter} from 'react-native';
import EditorManager from 'react-native-wordpress-editor';

let eventSubscribers = [];

export default class EditorScreen extends Component {
  static navigatorButtons = {
    rightButtons: [
      {
        title: 'Edit',
        id: 'edit'
      }
    ]
  };

  constructor(props) {
    super(props);
    // if you want to listen on navigator events, set this up
    this.props.navigator.setOnNavigatorEvent(this.onNavigatorEvent.bind(this));

    var subscription = NativeAppEventEmitter.addListener(
        'EventEditorDidPressMedia', () => {
          console.warn('Clicked Add Media!');
        }
    );
    eventSubscribers.push(subscription);
  }

  componentWillUnmount() {
    eventSubscribers.forEach((eventListener) => eventListener.remove());
  }

  onNavigatorEvent(event) {
    if (event.id == 'edit') {
      this.setEditingState(true);
    } else if (event.id == 'done') {
      this.setEditingState(false);
    }
  }

  setEditingState(editing) {
    if (editing) {
      this.props.navigator.setButtons({rightButtons: [
        {
          title: 'Done',
          id: 'done'
        }
      ]});
      this.props.navigator.setTitle('Edit');
    } else {
      this.props.navigator.setButtons({rightButtons: [
        {
          title: 'Edit',
          id: 'edit'
        }
      ]});
      this.props.navigator.setTitle('Preview');
    }
    EditorManager.setEditingState(editing);
  }

  /*
    This screen can be empty since all the content comes form the external view controller.
    If necessary, navigation logic, event handling and redux logic can go here
  */

  render() {
    return null;
  }
}
