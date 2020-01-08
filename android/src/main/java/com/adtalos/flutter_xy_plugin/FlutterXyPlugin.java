package com.adtalos.flutter_xy_plugin;

import android.support.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.xy.LandingPageActivity;
import io.flutter.plugin.xy.SDK;

/**
 * FlutterXyPlugin
 */
public class FlutterXyPlugin implements FlutterPlugin, MethodCallHandler {
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_xy_plugin");
        channel.setMethodCallHandler(new FlutterXyPlugin());
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_xy_plugin");
        channel.setMethodCallHandler(new FlutterXyPlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "setOAID":
                SDK.setOAID(call.<String>argument("oaid"));
                result.success(null);
                break;
            case "isLandingPageDisplayActionBarEnabled":
                result.success(LandingPageActivity.isDisplayActionBarEnabled());
                break;
            case "isLandingPageAnimationEnabled":
                result.success(LandingPageActivity.isAnimationEnabled());
                break;
            case "isLandingPageFullScreenEnabled":
                result.success(LandingPageActivity.isFullScreenEnabled());
                break;
            case "setLandingPageDisplayActionBarEnabled":
                LandingPageActivity.setDisplayActionBarEnabled(call.<Boolean>argument("enabled"));
                result.success(null);
                break;
            case "setLandingPageAnimationEnabled":
                LandingPageActivity.setAnimationEnabled(call.<Boolean>argument("enabled"));
                result.success(null);
                break;
            case "setLandingPageFullScreenEnabled":
                LandingPageActivity.setFullScreenEnabled(call.<Boolean>argument("enabled"));
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
}
