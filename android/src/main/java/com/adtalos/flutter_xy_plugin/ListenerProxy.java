package com.adtalos.flutter_xy_plugin;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.xy.DefaultCustomListener;
import io.flutter.plugin.xy.Listener;
import io.flutter.plugin.xy.VideoController;
import io.flutter.plugin.xy.VideoListener;

class ListenerProxy implements Listener, VideoListener, DefaultCustomListener {
    private String unitId;
    private MethodChannel channel;

    ListenerProxy(String unitId, MethodChannel channel) {
        this.unitId = unitId;
        this.channel = channel;
    }

    @Override
    public void on(String name, final String data) {
        if (channel != null) {
            channel.invokeMethod(name, new HashMap<String, Object>() {{
                put("id", unitId);
                put("data", data);
            }});
        }
    }

    @Override
    public void onRendered() {
        if (channel != null) {
            channel.invokeMethod("onRendered",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onImpressionFinished() {
        if (channel != null) {
            channel.invokeMethod("onImpressionFinished",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onImpressionFailed() {
        if (channel != null) {
            channel.invokeMethod("onImpressionFailed",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onImpressionReceivedError(final int errorCode, final String description) {
        if (channel != null) {
            channel.invokeMethod("onImpressionReceivedError",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                        put("error", errorCode + ":" + description);
                    }});
        }
    }

    @Override
    public void onLoaded() {
        if (channel != null) {
            channel.invokeMethod("onLoaded",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onFailedToLoad(final Exception e) {
        if (channel != null) {
            channel.invokeMethod("onFailedToLoad",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                        put("error", e.getMessage());
                    }});
        }
    }

    @Override
    public void onOpened() {
        if (channel != null) {
            channel.invokeMethod("onOpened",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onClicked() {
        if (channel != null) {
            channel.invokeMethod("onClicked",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onLeftApplication() {
        if (channel != null) {
            channel.invokeMethod("onLeftApplication",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onClosed() {
        if (channel != null) {
            channel.invokeMethod("onClosed",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onVideoLoad(final VideoController.Metadata metadata) {
        if (channel != null) {
            channel.invokeMethod("onVideoLoad",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                        put("metadata", new HashMap<String, Object>() {{
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
                    }});
        }
    }

    @Override
    public void onVideoStart() {
        if (channel != null) {
            channel.invokeMethod("onVideoStart",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onVideoPlay() {
        if (channel != null) {
            channel.invokeMethod("onVideoPlay",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onVideoPause() {
        if (channel != null) {
            channel.invokeMethod("onVideoPause",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onVideoEnd() {
        if (channel != null) {
            channel.invokeMethod("onVideoEnd",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onVideoVolumeChange(final double volume, final boolean muted) {
        if (channel != null) {
            channel.invokeMethod("onVideoVolumeChange",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
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
                        put("id", unitId);
                        put("currentTime", currentTime);
                        put("duration", duration);
                    }});
        }
    }

    @Override
    public void onVideoError() {
        if (channel != null) {
            channel.invokeMethod("onVideoError",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

    @Override
    public void onVideoBreak() {
        if (channel != null) {
            channel.invokeMethod("onVideoBreak",
                    new HashMap<String, Object>() {{
                        put("id", unitId);
                    }});
        }
    }

}
