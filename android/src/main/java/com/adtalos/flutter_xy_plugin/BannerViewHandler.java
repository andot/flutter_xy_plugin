package com.adtalos.flutter_xy_plugin;

import android.app.Activity;
import android.content.Context;
import android.widget.RelativeLayout;

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
        ListenerProxy listenerProxy = new ListenerProxy(getChannel());
        view.setSize(size);
        view.setAnimationEnabled(true);
        view.setCarouselModeEnabled(true);
        view.setListener(listenerProxy);
        view.setDefaultCustomListener(listenerProxy);
        views.put(unitId, view);
    }
}
