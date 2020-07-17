package com.adtalos.flutter_xy_plugin;

import android.app.Activity;
import android.content.Context;
import androidx.annotation.NonNull;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.platform.PlatformViewRegistry;
import io.flutter.plugin.xy.Controller;
import io.flutter.plugin.xy.LandingPageActivity;
import io.flutter.plugin.xy.SDK;

/**
 * FlutterXyPlugin
 */
public class FlutterXyPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {
    private final static FlutterXyPlugin plugin = new FlutterXyPlugin();
    private final static HashMap<String, Controller> controllers = new HashMap<>();
    private Context applicationContext;
    private MethodChannel channel;
    private Activity activity;
    // This is always null when not using v2 embedding.
    private FlutterPluginBinding pluginBinding;

    /**
     * Registers a plugin with the v1 embedding api {@code io.flutter.plugin.common}.
     *
     * <p>Calling this will register the plugin with the passed registrar. However, plugins
     * initialized this way won't react to changes in activity or context.
     *
     * @param registrar connects this plugin's {@link
     *                  io.flutter.plugin.common.MethodChannel.MethodCallHandler} to its {@link
     *                  io.flutter.plugin.common.BinaryMessenger}.
     */
    public static void registerWith(Registrar registrar) {
        if (registrar.activity() == null) {
            // If a background Flutter view tries to register the plugin, there will be no activity from the registrar.
            // We stop the registering process immediately because the flutter_xy_plugin requires an activity.
            return;
        }
        plugin.initializePlugin(registrar.context(), registrar.activity(), registrar.messenger(), registrar.platformViewRegistry());
    }

    private void initializePlugin(
            Context applicationContext, Activity activity, BinaryMessenger messenger, PlatformViewRegistry registry) {
        this.activity = activity;
        this.applicationContext = applicationContext;
        this.channel = new MethodChannel(messenger, "flutter_xy_plugin");
        channel.setMethodCallHandler(this);
        registry.registerViewFactory("flutter_xy_plugin/XyView", new XyViewFactory(messenger));
        SDK.init(applicationContext);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        pluginBinding = binding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        pluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        initializePlugin(
                pluginBinding.getApplicationContext(),
                binding.getActivity(),
                pluginBinding.getBinaryMessenger(),
                pluginBinding.getPlatformViewRegistry());
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        initializePlugin(
                pluginBinding.getApplicationContext(),
                binding.getActivity(),
                pluginBinding.getBinaryMessenger(),
                pluginBinding.getPlatformViewRegistry());
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "requestPermissions":
                SDK.requestPermissions(activity);
                result.success(null);
                break;
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
            case "createController": {
                String id = call.argument("id");
                int type = call.argument("type");
                Controller controller = new Controller(id, type);
                controllers.put(id, controller);
                XyListener listener = new XyListener(channel, id);
                controller.setListener(listener);
                controller.setDefaultCustomListener(listener);
                controller.setVideoListener(listener);
                boolean immersive = call.argument("immersive");
                controller.setImmersiveMode(immersive);
                if (call.hasArgument("retry")) {
                    int retry = call.argument("retry");
                    controller.autoRetry(retry);
                }
                result.success(null);
                break;
            }
            case "load": {
                String id = call.argument("id");
                Controller controller = controllers.get(id);
                controller.load();
                result.success(null);
                break;
            }
            case "show": {
                String id = call.argument("id");
                Controller controller = controllers.get(id);
                if (call.hasArgument("timeout")) {
                    int timeout = call.argument("timeout");
                    controller.show(timeout);
                } else {
                    controller.show();
                }
                result.success(null);
                break;
            }
            case "isLoaded": {
                String id = call.argument("id");
                Controller controller = controllers.get(id);
                result.success(controller.isLoaded());
                break;
            }
            default:
                result.notImplemented();
        }
    }
}
