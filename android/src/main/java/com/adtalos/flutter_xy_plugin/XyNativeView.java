package com.adtalos.flutter_xy_plugin;

import android.content.Context;
import android.support.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.xy.VideoController;
import io.flutter.plugin.xy.View;

public class XyNativeView extends XyView {
    public XyNativeView(Context context, BinaryMessenger messenger, int id, Map<String, Object> params) {
        super(context, messenger, id, params);
    }

    @Override
    protected void initChannel(BinaryMessenger messenger, int id) {
        channel = new MethodChannel(messenger, "flutter_xy_plugin/XyNativeView_" + id);
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        final View view = (View) getView();
        final VideoController videoController = view.getVideoController();
        switch (call.method) {
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
                super.onMethodCall(call, result);
                break;
        }
    }

}
