package com.example;

import android.support.annotation.NonNull;

import com.facebook.react.ReactPackage;
import com.reactnativenavigation.NavigationApplication;
import com.wix.RNWordpressEditor.*;
import com.wix.RNWordpressEditor.BuildConfig;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Created by yedidyak on 28/07/2016.
 */
public class App extends NavigationApplication {
    @Override
    public boolean isDebug() {
        return true;
    }

    @NonNull
    @Override
    public List<ReactPackage> createAdditionalReactPackages() {
        return Arrays.<ReactPackage>asList(new RNWordpressEditorPackage());
    }
}
