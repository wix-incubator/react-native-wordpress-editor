package com.wix.RNWordpressEditor;

import android.os.Bundle;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

import org.wordpress.android.editor.EditorFragment;

/**
 * Created by yedidyak on 24/07/2016.
 */
public class EditorManager extends ReactContextBaseJavaModule{

    private static EditorFragment editorFragment;
    private static String originalTitle = "";
    private static String originalBody = "";

    public EditorManager(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "RNWordPressEditorManager";
    }

    @ReactMethod
    public void setBottomToolbarHidden(boolean animated){
        //TODO
    }

    @ReactMethod
    public void addImages(ReadableArray images){
        //TODO
    }

    @ReactMethod
    public void getPostData(Promise promise){
        //TODO
    }

    @ReactMethod
    public void isPostChanged(Promise promise){
        //TODO
    }

    @ReactMethod
    public void resetStateToInitial(){
        //TODO
    }

    @ReactMethod
    public void showKeyboardIfEditing(){
        //TODO
    }

    @ReactMethod
    public void dismissKeyboardIfEditing(){
        //TODO
    }

    @ReactMethod
    public void setEditingState(boolean isEditing){
        validateFragment("setEditingState");
        editorFragment.setEditable(isEditing);
    }

    private void validateFragment(String method) {
        if(editorFragment == null) {
            throw new RuntimeException("Called " + method + " when there was no EditorFragment!");
        }
    }

    public static EditorFragment getFragment(Bundle props) {

        if (props != null) {
            Bundle post = props.getBundle("post");
            if (post != null) {
                originalTitle = post.getString("title");
                originalBody = post.getString("body");
            }
        }

        editorFragment = EditorFragment.newInstance(originalTitle, originalBody);
        editorFragment.setShowHtmlButtonVisible(false);

        editorFragment.setEditable(false);

        return editorFragment;
    }
}
