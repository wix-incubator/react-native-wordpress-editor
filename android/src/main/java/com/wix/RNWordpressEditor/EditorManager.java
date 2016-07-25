package com.wix.RNWordpressEditor;

import android.os.Bundle;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;

import org.wordpress.android.editor.EditorFragment;
import org.wordpress.android.editor.EditorFragmentAbstract;
import org.wordpress.android.util.helpers.MediaFile;

/**
 * Created by yedidyak on 24/07/2016.
 */
public class EditorManager /*extends ReactContextBaseJavaModule*/ implements EditorFragmentAbstract.EditorFragmentListener {

    private static EditorFragment editorFragment;
    private static String originalTitle = "";
    private static String originalBody = "";

    private static EditorManager instance;

    public static EditorManager getInstance() {
        return instance;
    }

    public EditorManager() {//ReactApplicationContext reactContext) {
        //super(reactContext);
        instance = this;
    }

//    @Override
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
        editorFragment.showKeyboardIfEditing();
    }

    @ReactMethod
    public void dismissKeyboardIfEditing(){
        editorFragment.dismissKeyboard();
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

        //TODO this needs the reactContext
        if (instance == null) {
            new EditorManager();
        }

        editorFragment = EditorFragment.newInstance(instance, originalTitle, originalBody);
        editorFragment.setShowHtmlButtonVisible(false);

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
