package com.adtalos.flutter_xy_plugin;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class XyNativeViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;

    public XyNativeViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new XyNativeView(context, messenger, viewId, params);
    }

    public static void registerWith(PluginRegistry registry) {
        final String key = "XyNativeView";
        if (registry.hasPlugin(key)) return;
        PluginRegistry.Registrar registrar = registry.registrarFor(key);
        registrar.platformViewRegistry().registerViewFactory("flutter_xy_plugin/XyNativeView", new XyNativeViewFactory(registrar.messenger()));
    }

}
