package com.adtalos.flutter_xy_plugin;

import android.content.Context;
import android.graphics.Rect;
import android.support.annotation.NonNull;
import android.view.View;
import android.widget.RelativeLayout;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.xy.Size;

public class XyView implements PlatformView, MethodChannel.MethodCallHandler {
    private final io.flutter.plugin.xy.View view;
    protected MethodChannel channel;

    public XyView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
        view = new io.flutter.plugin.xy.View(context);
        initChannel(messenger, id);
        ListenerProxy listener = new ListenerProxy(channel);
        view.setListener(listener);
        view.setDefaultCustomListener(listener);
        view.getVideoController().setVideoListener(listener);
        view.setOnCloseListener(new io.flutter.plugin.xy.View.OnCloseListener() {
            @Override
            public boolean onClose() {
                channel.invokeMethod("onViewClose", null);
                return false;
            }
        });
        if (params.containsKey("size")) {
            switch ((String)params.get("size")) {
                case "BANNER":
                    view.setSize(Size.BANNER);
                    break;
                case "NATIVE":
                    view.setSize(Size.NATIVE);
                    break;
                case "NATIVE_1TO1":
                    view.setSize(Size.NATIVE_1TO1);
                    break;
                case "NATIVE_2TO1":
                    view.setSize(Size.NATIVE_2TO1);
                    break;
                case "NATIVE_3TO2":
                    view.setSize(Size.NATIVE_3TO2);
                    break;
                case "NATIVE_4TO3":
                    view.setSize(Size.NATIVE_4TO3);
                    break;
                case "NATIVE_11TO4":
                    view.setSize(Size.NATIVE_11TO4);
                    break;
                case "NATIVE_16TO9":
                    view.setSize(Size.NATIVE_16TO9);
                    break;
            }
        }
        if (params.containsKey("width") && params.containsKey("height")) {
            int width = (int)params.get("width");
            int height = (int)params.get("height");
            view.setSize(new Size(width, height));
        }
        if (params.containsKey("animation")) {
            view.setAnimationEnabled((boolean)params.get("animation"));
        }
        if (params.containsKey("carousel")) {
            view.setCarouselModeEnabled((boolean)params.get("carousel"));
        }
        if (params.containsKey("retry")) {
            view.autoRetry((int)params.get("retry"));
        }
        if (params.containsKey("id")) {
            System.out.println(params.get("id"));
            System.out.println(view.getSize().getAspectRatio());
            view.load((String)params.get("id"), true);
        }
    }

    protected void initChannel(BinaryMessenger messenger, int id) {
        channel = new MethodChannel(messenger, "flutter_xy_plugin/XyView_" + id);
        channel.setMethodCallHandler(this);
    }

    @Override
    public View getView() {
        System.out.println(view);
        Rect rect = new Rect();
        System.out.println("getGlobalVisibleRect: " + view.getGlobalVisibleRect(rect));
        System.out.println("getLocalVisibleRect: " + view.getLocalVisibleRect(rect));
        System.out.println("isShown: " + view.isShown());
        System.out.println("hasWindowFocus: " + view.hasWindowFocus());
        return view;
    }

    @Override
    public void onFlutterViewAttached(@NonNull View flutterView) {
        System.out.println("onFlutterViewAttached");
        view.resume();
    }

    @Override
    public void onFlutterViewDetached() {
        System.out.println("onFlutterViewDetached");
        view.pause();
    }

    @Override
    public void dispose() {
        System.out.println("dispose");
        view.destroy();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "impressionReport":
                view.impressionReport();
                result.success(null);
                break;
            case "load":
                String id = call.argument("id");
                view.load(id, false);
                result.success(null);
                break;
            case "isLoaded":
                result.success(view.isLoaded());
                break;
            case "show":
                view.show();
                result.success(null);
                break;
            case "render":
                view.render();
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
