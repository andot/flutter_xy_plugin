package com.adtalos.flutter_xy_plugin;

import android.app.Activity;
import android.content.Context;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

import io.flutter.plugin.common.MethodChannel;

abstract class AbstractHandler {
    private Context context;
    private Activity activity;
    private MethodChannel channel;
    private RelativeLayout layout;

    AbstractHandler(Context context,
                    Activity activity,
                    MethodChannel channel) {
        this.context = context;
        this.activity = activity;
        this.channel = channel;
    }

    Context getApplicationContext() {
        return context;
    }

    RelativeLayout getLayout() {
        if (layout == null || layout.getContext() != activity) {
            layout = new RelativeLayout(activity);
            activity.addContentView(layout, new LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT));
        }
        return layout;
    }

    Activity getActivity() {
        return activity;
    }

    MethodChannel getChannel() {
        return channel;
    }
}
