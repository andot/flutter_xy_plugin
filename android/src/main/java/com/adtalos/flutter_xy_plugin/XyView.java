package com.adtalos.flutter_xy_plugin;

import android.content.Context;
import android.support.annotation.NonNull;
import android.view.View;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.xy.Size;
import io.flutter.plugin.xy.VideoController;

public class XyView implements PlatformView, MethodChannel.MethodCallHandler {
    private final io.flutter.plugin.xy.View view;
    private final MethodChannel channel;

    public XyView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
        view = new io.flutter.plugin.xy.View(context);
        channel = new MethodChannel(messenger, "flutter_xy_plugin/XyView_" + id);
        channel.setMethodCallHandler(this);
        XyListener listener = new XyListener(channel, "");
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
            switch ((String) params.get("size")) {
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
            int width = (int) params.get("width");
            int height = (int) params.get("height");
            view.setSize(new Size(width, height));
        }
        if (params.containsKey("animation")) {
            view.setAnimationEnabled((boolean) params.get("animation"));
        }
        if (params.containsKey("carousel")) {
            view.setCarouselModeEnabled((boolean) params.get("carousel"));
        }
        if (params.containsKey("retry")) {
            view.autoRetry((int) params.get("retry"));
        }
        if (params.containsKey("id")) {
            view.load((String) params.get("id"), true);
        }
    }


    @Override
    public View getView() {
        return view;
    }

    @Override
    public void onFlutterViewAttached(@NonNull View flutterView) {
        view.resume();
    }

    @Override
    public void onFlutterViewDetached() {
        view.pause();
    }

    @Override
    public void dispose() {
        System.out.println("dispose");
        view.destroy();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        final VideoController videoController = view.getVideoController();
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
            case "getMetadata":
                final VideoController.Metadata metadata = videoController.getMetadata();
                result.success(new HashMap<String, Object>() {{
                    put("currentTime", metadata.getCurrentTime());
                    put("duration", metadata.getDuration());
                    put("videoWidth", metadata.getVideoWidth());
                    put("videoHeight", metadata.getVideoHeight());
                    put("autoplay", metadata.isAutoplay());
                    put("muted", metadata.isMuted());
                    put("volume", metadata.getVolume());
                    put("type", metadata.getType());
                    put("status", metadata.getStatus());
                    put("ended", videoController.isEnded());
                }});
                break;
            case "hasVideo":
                result.success(videoController.hasVideo());
                break;
            case "isEnded":
                result.success(videoController.isEnded());
                break;
            case "isPlaying":
                result.success(videoController.isPlaying());
                break;
            case "mute":
                boolean mute = call.argument("mute");
                videoController.mute(mute);
                result.success(null);
                break;
            case "play":
                videoController.play();
                result.success(null);
                break;
            case "pause":
                videoController.pause();
                result.success(null);
                break;
            default:
                result.notImplemented();
                break;
        }
    }
}
