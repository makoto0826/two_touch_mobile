package com.makoto0826.two_touch_mobile

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

class Rcs380Plugin(private val context: Context) : FlutterPlugin {

    companion object {
        private const val METHOD_CHANNEL = "com.makoto0826.two_touch_mobile/rcs380"
        private const val EVENT_CHANNEL = "com.makoto0826.two_touch_mobile/rcs380-stream"
        private val TAG = Rcs380Plugin::javaClass.name
    }

    private var methodChannel: MethodChannel? = null;
    private var eventChannel: EventChannel? = null;
    private var rcs380Service: Rcs380Service? = null;

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val messenger = binding.getBinaryMessenger()

        rcs380Service = Rcs380Service(context);

        methodChannel = MethodChannel(messenger, METHOD_CHANNEL)
        methodChannel!!.setMethodCallHandler(rcs380Service)

        eventChannel = EventChannel(messenger, EVENT_CHANNEL)
        eventChannel!!.setStreamHandler(rcs380Service)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        rcs380Service!!.dispose();
        rcs380Service = null;

        methodChannel!!.setMethodCallHandler(null)
        methodChannel = null

        eventChannel!!.setStreamHandler(null)
        eventChannel = null
    }
}
