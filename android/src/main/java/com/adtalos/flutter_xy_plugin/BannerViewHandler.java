package com.adtalos.flutter_xy_plugin;

import android.app.Activity;
import android.content.Context;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.xy.Size;
import io.flutter.plugin.xy.View;

class BannerViewHandler extends ViewHandler {

    BannerViewHandler(Context context,
                      Activity activity,
                      MethodChannel channel) {
        super(context, activity, channel);
    }

    @Override
    public void prepare(final String unitId, int width, int height) {
        if (views.containsKey(unitId)) {
            views.get(unitId).setVisibility(android.view.View.VISIBLE);
            return;
        }
        Size size = new Size(width, height);
        final View view = new View(getActivity());
        XyListener xyListener = new XyListener(getChannel());
        view.setSize(size);
        view.setAnimationEnabled(true);
        view.setCarouselModeEnabled(true);
        view.setListener(xyListener);
        view.setDefaultCustomListener(xyListener);
        views.put(unitId, view);
    }
}
