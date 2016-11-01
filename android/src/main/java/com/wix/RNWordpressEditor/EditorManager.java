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

package com.wix.RNWordpressEditor;

import android.os.Bundle;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.RCTNativeAppEventEmitter;

import org.wordpress.android.editor.EditorFragment;
import org.wordpress.android.editor.EditorFragmentAbstract;
import org.wordpress.android.util.helpers.MediaFile;

/**
 * Created by yedidyak on 24/07/2016.
 */
public class EditorManager extends ReactContextBaseJavaModule implements EditorFragmentAbstract.EditorFragmentListener {

    private static EditorFragment editorFragment;
    private static String originalTitle = "";
    private static String originalBody = "";

    private static EditorManager instance;

    public static EditorManager getInstance() {
        return instance;
    }

    public EditorManager(ReactApplicationContext reactContext) {
        super(reactContext);
        instance = this;
    }

    //    @Override
    public String getName() {
        return "RNWordPressEditorManager";
    }

    @ReactMethod
    public void setBottomToolbarHidden(final boolean hidden, final boolean animated){
        //This is just here to match the iOS API, but the prduct doesn;t have a bottom toolbar
    }

    @ReactMethod
    public void addImages(final ReadableArray images){
        getReactApplicationContext().runOnUiQueueThread(new Runnable() {
            @Override
            public void run() {
                for(int i = 0; i < images.size(); i++) {
                    String url = images.getMap(i).getString("url");
                    editorFragment.appendMediaFile(url);
                }
            }
        });
    }

    @ReactMethod
    public void getPostData(final Promise promise){
        CharSequence title = editorFragment.getTitle();
        CharSequence body = editorFragment.getContent();

        if(title == null || body == null) {
            promise.reject("EDITOR", "FAILED TO GET POST DATA");
            return;
        }

        WritableMap post = Arguments.createMap();
        post.putString("title", title.toString());
        post.putString("body", body.toString());
        promise.resolve(post);
    }

    @ReactMethod
    public void isPostChanged(final Promise promise){
        getReactApplicationContext().runOnUiQueueThread(new Runnable() {
            @Override
            public void run() {
                String title = editorFragment.getTitle().toString();
                String body = editorFragment.getContent().toString();
                boolean changed = !title.equals(originalTitle) || !body.equals(originalBody);
                promise.resolve(changed);
            }
        });
    }

    @ReactMethod
    public void resetStateToInitial(){
        getReactApplicationContext().runOnUiQueueThread(new Runnable() {
            @Override
            public void run() {
                editorFragment.setTitle(originalTitle);
                editorFragment.setContent(originalBody);
                editorFragment.updateVisualEditorFields();
            }
        });
    }

    @ReactMethod
    public void showKeyboardIfEditing(){
        getReactApplicationContext().runOnUiQueueThread(new Runnable() {
            @Override
            public void run() {
                editorFragment.showKeyboardIfEditing();
            }
        });
    }

    @ReactMethod
    public void dismissKeyboardIfEditing(){
        getReactApplicationContext().runOnUiQueueThread(new Runnable() {
            @Override
            public void run() {
                editorFragment.dismissKeyboard();
            }
        });
    }

    @ReactMethod
    public void setEditingState(final boolean isEditing){
        validateFragment("setEditingState");
        getReactApplicationContext().runOnUiQueueThread(new Runnable() {
            @Override
            public void run() {
                editorFragment.setEditable(isEditing);
            }
        });
    }

    private void validateFragment(String method) {
        if(editorFragment == null) {
            throw new RuntimeException("Called " + method + " when there was no EditorFragment!");
        }
    }

    public static EditorFragment getFragment(Bundle props) {

        String placeholderTitle = "";
        String placeholderBody = "";
        boolean editable = false;

        if (props != null) {
            Bundle post = props.getBundle("post");
            if (post != null) {
                originalTitle = post.getString("title");
                originalBody = post.getString("body");
                editable = post.getBoolean("isNewPost");
            }
            Bundle placeHolders = props.getBundle("placeHolders");
            if (placeHolders != null) {
                placeholderTitle = placeHolders.getString("title");
                placeholderBody = placeHolders.getString("body");
            }
        }

        editorFragment = EditorFragment.newInstance(instance, originalTitle, originalBody);
        editorFragment.setShowHtmlButtonVisible(false);
        editorFragment.setEditable(editable);
        editorFragment.setTitlePlaceholder(placeholderTitle);
        editorFragment.setContentPlaceholder(placeholderBody);
        editorFragment.setEditorFragmentListener(instance);

        return editorFragment;
    }

    //Listeners

    @Override
    public void onEditorFragmentInitialized() {

    }

    @Override
    public void onSettingsClicked() {

    }

    @Override
    public void onAddMediaClicked() {
        getReactApplicationContext().getJSModule(RCTNativeAppEventEmitter.class).emit("EventEditorDidPressMedia", null);
    }

    @Override
    public void onMediaRetryClicked(String mediaId) {

    }

    @Override
    public void onMediaUploadCancelClicked(String mediaId, boolean delete) {

    }

    @Override
    public void onFeaturedImageChanged(long mediaId) {

    }

    @Override
    public void onVideoPressInfoRequested(String videoId) {

    }

    @Override
    public String onAuthHeaderRequested(String url) {
        return null;
    }

    @Override
    public void saveMediaFile(MediaFile mediaFile) {

    }

    @Override
    public void onTrackableEvent(EditorFragmentAbstract.TrackableEvent event) {

    }
}
