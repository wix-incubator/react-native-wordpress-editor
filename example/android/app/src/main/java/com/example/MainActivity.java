package com.example;

import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainReactPackage;
import com.reactnativenavigation.activities.RootActivity;
import com.reactnativenavigation.packages.RnnPackage;
import com.wix.RNWordpressEditor.RNWordpressEditorPackage;

import java.util.Arrays;
import java.util.List;

public class MainActivity extends RootActivity {

    @Override
    public List<ReactPackage> getPackages() {
        return Arrays.<ReactPackage>asList(
            new MainReactPackage(),
            new RnnPackage(),
            new RNWordpressEditorPackage()
        );
    }
}
