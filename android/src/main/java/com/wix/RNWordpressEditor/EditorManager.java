package com.wix.RNWordpressEditor;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;

/**
 * Created by yedidyak on 24/07/2016.
 */
public class EditorManager extends ReactContextBaseJavaModule{

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
        //TODO
    }
}
