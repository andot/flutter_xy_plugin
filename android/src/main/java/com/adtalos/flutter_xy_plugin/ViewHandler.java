package com.adtalos.flutter_xy_plugin;

import android.app.Activity;
import android.content.Context;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.RelativeLayout.LayoutParams;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.xy.View;

abstract class ViewHandler extends AbstractHandler {
    static final int ABSOLUTE = 0;
    static final int TOP_LEFT = 1;
    static final int TOP_CENTER = 2;
    static final int TOP_RIGHT = 3;
    static final int MIDDLE_LEFT = 4;
    static final int MIDDLE_CENTER = 5;
    static final int MIDDLE_RIGHT = 6;
    static final int BOTTOM_LEFT = 7;
    static final int BOTTOM_CENTER = 8;
    static final int BOTTOM_RIGHT = 9;

    ViewHandler(Context context,
                Activity activity,
                MethodChannel channel) {
        super(context, activity, channel);
    }

    Map<String, View> views = new ConcurrentHashMap<>();

    public abstract void prepare(String unitId, int width, int height);

    LayoutParams getAbsoluteLayoutParams(int x, int y) {
        LayoutParams layoutParams = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
        layoutParams.leftMargin = x;
        layoutParams.topMargin = y;
        layoutParams.alignWithParent = true;
        return layoutParams;
    }

    LayoutParams getRelationLayoutParams(int position, int y) {
        LayoutParams layoutParams = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
        if (y > 0) {
            layoutParams.topMargin = y;
        } else if (y < 0) {
            layoutParams.bottomMargin = -y;
        }
        switch (position) {
            case ABSOLUTE:
            case TOP_LEFT:
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
                break;
            case TOP_RIGHT:
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
                break;
            case MIDDLE_LEFT:
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
                layoutParams.addRule(RelativeLayout.CENTER_VERTICAL);
                break;
            case MIDDLE_CENTER:
                layoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
                layoutParams.addRule(RelativeLayout.CENTER_VERTICAL);
                break;
            case MIDDLE_RIGHT:
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
                layoutParams.addRule(RelativeLayout.CENTER_VERTICAL);
                break;
            case BOTTOM_LEFT:
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
                break;
            case BOTTOM_CENTER:
                layoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
                break;
            case BOTTOM_RIGHT:
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_RIGHT);
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
                break;
            case TOP_CENTER:
            default:
                layoutParams.addRule(RelativeLayout.ALIGN_PARENT_TOP);
                layoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL);
                break;
        }
        return layoutParams;
    }

    void showAbsolute(final String unitId, final int width, final int height, final int x, final int y) {
        final Activity activity = getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ViewHandler.this.prepare(unitId, width, height);
                View view = views.get(unitId);
                if (view.getParent() != null) {
                    ((ViewGroup) view.getParent()).removeView(view);
                }
                getLayout().addView(view, ViewHandler.this.getAbsoluteLayoutParams(x, y));
                view.load(unitId);
            }
        });
    }

    void showRelative(final String unitId, final int width, final int height, final int position, final int y) {
        final Activity activity = getActivity();
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                ViewHandler.this.prepare(unitId, width, height);
                View view = views.get(unitId);
                if (view.getParent() != null) {
                    ((ViewGroup) view.getParent()).removeView(view);
                }
                getLayout().addView(view, ViewHandler.this.getRelationLayoutParams(position, y));
                view.load(unitId);
            }
        });
    }

    void destroy(final String unitId) {
        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                View view = views.get(unitId);
                if (view != null) {
                    if (view.getParent() != null) {
                        ((ViewGroup) view.getParent()).removeView(view);
                    }
                    view.destroy();
                }
            }
        });
    }

    void pause(final String unitId) {
        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                View view = views.get(unitId);
                if (view != null) view.pause();
            }
        });
    }

    void resume(final String unitId) {
        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                View view = views.get(unitId);
                if (view != null) view.resume();
            }
        });
    }

}
