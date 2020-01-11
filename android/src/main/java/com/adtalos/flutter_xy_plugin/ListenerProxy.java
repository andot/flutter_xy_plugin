package com.adtalos.flutter_xy_plugin;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.xy.DefaultCustomListener;
import io.flutter.plugin.xy.Listener;
import io.flutter.plugin.xy.VideoController;
import io.flutter.plugin.xy.VideoListener;

class ListenerProxy implements Listener, VideoListener, DefaultCustomListener {
    private MethodChannel channel;

    ListenerProxy(MethodChannel channel) {
        this.channel = channel;
    }

    @Override
    public void on(String name, final String data) {
        System.out.println("onCustom: " + name);
        if (channel != null) {
            channel.invokeMethod(name, new HashMap<String, Object>() {{
                put("data", data);
            }});
        }
    }

    @Override
    public void onRendered() {
        System.out.println("onRendered");
        if (channel != null) {
            channel.invokeMethod("onRendered", null);
        }
    }

    @Override
    public void onImpressionFinished() {
        System.out.println("onImpressionFinished");
        if (channel != null) {
            channel.invokeMethod("onImpressionFinished",
                    null);
        }
    }

    @Override
    public void onImpressionFailed() {
        System.out.println("onImpressionFailed");
        if (channel != null) {
            channel.invokeMethod("onImpressionFailed",
                    null);
        }
    }

    @Override
    public void onImpressionReceivedError(final int errorCode, final String description) {
        System.out.println("onImpressionReceivedError");
        if (channel != null) {
            channel.invokeMethod("onImpressionReceivedError",
                    new HashMap<String, Object>() {{
                        put("error", errorCode + ":" + description);
                    }});
        }
    }

    @Override
    public void onLoaded() {
        System.out.println("onLoaded");
        if (channel != null) {
            channel.invokeMethod("onLoaded",
                    null);
        }
    }

    @Override
    public void onFailedToLoad(final Exception e) {
        System.out.println("onFailedToLoad");
        if (channel != null) {
            channel.invokeMethod("onFailedToLoad",
                    new HashMap<String, Object>() {{
                        put("error", e.getMessage());
                    }});
        }
    }

    @Override
    public void onOpened() {
        System.out.println("onOpened");
        if (channel != null) {
            channel.invokeMethod("onOpened",
                    null);
        }
    }

    @Override
    public void onClicked() {
        System.out.println("onClicked");
        if (channel != null) {
            channel.invokeMethod("onClicked",
                    null);
        }
    }

    @Override
    public void onLeftApplication() {
        System.out.println("onLeftApplication");
        if (channel != null) {
            channel.invokeMethod("onLeftApplication",
                    null);
        }
    }

    @Override
    public void onClosed() {
        System.out.println("onClosed");
        if (channel != null) {
            channel.invokeMethod("onClosed",
                    null);
        }
    }

    @Override
    public void onVideoLoad(final VideoController.Metadata metadata) {
        if (channel != null) {
            channel.invokeMethod("onVideoLoad",
                    new HashMap<String, Object>() {{
                        put("currentTime", metadata.getCurrentTime());
                        put("duration", metadata.getDuration());
                        put("videoWidth", metadata.getVideoWidth());
                        put("videoHeight", metadata.getVideoHeight());
                        put("autoplay", metadata.isAutoplay());
                        put("muted", metadata.isMuted());
                        put("volume", metadata.getVolume());
                        put("type", metadata.getType());
                        put("status", metadata.getStatus());
                        put("ended", false);
                    }});
        }
    }

    @Override
    public void onVideoStart() {
        if (channel != null) {
            channel.invokeMethod("onVideoStart",
                    null);
        }
    }

    @Override
    public void onVideoPlay() {
        if (channel != null) {
            channel.invokeMethod("onVideoPlay",
                    null);
        }
    }

    @Override
    public void onVideoPause() {
        if (channel != null) {
            channel.invokeMethod("onVideoPause",
                    null);
        }
    }

    @Override
    public void onVideoEnd() {
        if (channel != null) {
            channel.invokeMethod("onVideoEnd",
                    null);
        }
    }

    @Override
    public void onVideoVolumeChange(final double volume, final boolean muted) {
        if (channel != null) {
            channel.invokeMethod("onVideoVolumeChange",
                    new HashMap<String, Object>() {{
                        put("volume", volume);
                        put("muted", muted);
                    }});
        }
    }

    @Override
    public void onVideoTimeUpdate(final double currentTime, final double duration) {
        if (channel != null) {
            channel.invokeMethod("onVideoTimeUpdate",
                    new HashMap<String, Object>() {{
                        put("currentTime", currentTime);
                        put("duration", duration);
                    }});
        }
    }

    @Override
    public void onVideoError() {
        if (channel != null) {
            channel.invokeMethod("onVideoError",
                    null);
        }
    }

    @Override
    public void onVideoBreak() {
        if (channel != null) {
            channel.invokeMethod("onVideoBreak",
                    null);
        }
    }

}
