import React, { Component } from 'react';
import EditorManager from 'react-native-wordpress-editor';

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
