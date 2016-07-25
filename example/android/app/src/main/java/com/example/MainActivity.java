package com.example;

//import com.facebook.react.ReactPackage;
//import com.facebook.react.shell.MainReactPackage;
//import com.reactnativenavigation.activities.RootActivity;
//import com.reactnativenavigation.packages.RnnPackage;
//import com.wix.RNWordpressEditor.RNWordpressEditorPackage;
//
//import java.util.Arrays;
//import java.util.List;
//
//public class MainActivity extends RootActivity {
//
//    @Override
//    public List<ReactPackage> getPackages() {
//        return Arrays.<ReactPackage>asList(
//            new MainReactPackage(),
//            new RnnPackage(),
//            new RNWordpressEditorPackage()
//        );
//    }
//}

import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.widget.FrameLayout;

import com.facebook.quicklog.identifiers.ReactNativeBridge;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.shell.MainReactPackage;
import com.reactnativenavigation.packages.RnnPackage;

import org.wordpress.android.editor.EditorFragmentAbstract;
import org.wordpress.android.util.helpers.MediaFile;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class MainActivity extends AppCompatActivity implements EditorFragmentAbstract.EditorFragmentListener{

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FrameLayout frame = new FrameLayout(this);
        frame.setId(1);
        setContentView(frame);

//        WritableMap map = Arguments.createMap();
//        WritableMap wProps = Arguments.createMap();
//        WritableMap post = Arguments.createMap();
//        post.putString("title", "Hello WorldPress");
//        post.putString("body", "cool HTML body <br><br> <img src=\"https://www.wpshrug.com/wp-content/uploads/2016/05/wordpress-winning-meme.jpg\" />");
//        wProps.putMap("post", post);
//        map.putMap("props", wProps);
//        ReadableMap props = map.getMap("props");

        Bundle props = new Bundle();
        Bundle post = new Bundle();
        post.putString("title", "Hello WorldPress");
        post.putString("body", "cool HTML body <br><br> <img src=\"https://www.wpshrug.com/wp-content/uploads/2016/05/wordpress-winning-meme.jpg\" />");
        props.putBundle("post", post);

        try {
            Class fragmentCreator = Class.forName("com.wix.RNWordpressEditor.EditorManager");
            Method getFragment = fragmentCreator.getMethod("getFragment", Bundle.class);

            Fragment fragment = (Fragment) getFragment.invoke(null, props);
            FragmentManager fm = getFragmentManager();
            FragmentTransaction transaction = fm.beginTransaction();
            transaction.add(1, fragment);
            transaction.commit();

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
    }

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
