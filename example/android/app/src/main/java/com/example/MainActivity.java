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
import android.view.Menu;
import android.view.MenuItem;
import android.widget.FrameLayout;

import com.wix.RNWordpressEditor.EditorManager;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Arrays;

public class MainActivity extends AppCompatActivity{

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        FrameLayout frame = new FrameLayout(this);
        frame.setId(1);
        setContentView(frame);

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

    ////////////
    private boolean editable = true;

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        menu.add(Menu.NONE, 0, Menu.NONE, "Toggle editing");
        menu.add(Menu.NONE, 1, Menu.NONE, "Dismiss keyboard");
        menu.add(Menu.NONE, 2, Menu.NONE, "Show keyboard if editing");
        menu.add(Menu.NONE, 3, Menu.NONE, "Append urls");
        menu.add(Menu.NONE, 4, Menu.NONE, "getPostData");
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch(item.getItemId()) {
            case 0:
                editable = !editable;
                EditorManager.getInstance().setEditingState(editable);
                return true;
            case 1:
                EditorManager.getInstance().dismissKeyboardIfEditing();
                return true;
            case 2:
                EditorManager.getInstance().showKeyboardIfEditing();
                return true;
            case 3:
                EditorManager.getInstance().addImages(Arrays.asList(
                        "http://images5.fanpop.com/image/photos/30800000/-Random-random-30843841-1920-1080.jpg",
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmVA-3wKULPQ8R-w8doY2ydkHsDbJpNYWN3ei6MkY8z6ASppZ-8ZzVPb4"));
                return true;
            case 4:
                EditorManager.getInstance().getPostData(null);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }
}
