package com.makoto0826.two_touch_mobile

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.hardware.usb.UsbDevice
import android.hardware.usb.UsbManager
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry;
import java.time.LocalDateTime
import java.lang.Exception
import kotlin.concurrent.thread

internal const val ACTION_USB_PERMISSION = "com.makoto0826.orecept.USB_PERMISSION"

class Rcs380Service(private val context: Context) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    companion object {
        private const val VENDOR_ID = 1356
        private const val PRODUCT_ID = 1731
        private val TAG = Rcs380Service::javaClass.name
    }

    private val usbManager = context.getSystemService(Context.USB_SERVICE) as UsbManager

    private var listing = false;

    private var wait = 200L;

    private var previousTag: String? = null;

    private var events: EventChannel.EventSink? = null;

    fun checkDevice(result: MethodChannel.Result) {
        val device = getDevice()
        result.success(device != null);
    }

    fun hasPermission(result: MethodChannel.Result) {
        val device = getDevice()

        if (device == null) {
            result.success(false);
            return;
        }

        val permission = usbManager.hasPermission(device);
        result.success(permission);
    }

    fun requestPermission(result: MethodChannel.Result) {
        val device = getDevice()

        if (device == null) {
            Log.d(TAG, "requestPermission:false")
            result.success(false)
            return
        }

        if (usbManager.hasPermission(device)) {
            Log.d(TAG, "requestPermission:true")
            result.success(true)
            return
        }

        val usbReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                context.unregisterReceiver(this)

                if (ACTION_USB_PERMISSION != intent.action) {
                    Log.d(TAG, "requestPermission:false")
                    result.success(false)
                    return
                }

                if (intent.getBooleanExtra(UsbManager.EXTRA_PERMISSION_GRANTED, false)) {
                    Log.d(TAG, "requestPermission:true")
                    result.success(true)
                } else {
                    Log.d(TAG, "requestPermission:false")
                    result.success(false)
                }
            }
        }

        val permissionIntent =
                PendingIntent.getBroadcast(context, 0, Intent(ACTION_USB_PERMISSION), 0)

        val filter = IntentFilter(ACTION_USB_PERMISSION)
        context.registerReceiver(usbReceiver, filter)

        usbManager.requestPermission(device, permissionIntent)
    }

    fun connect(result: MethodChannel.Result) {
        val device = getDevice()

        if (device == null) {
            result.success(false)
            return
        }

        if (!usbManager.hasPermission(device)) {
            result.success(false)
            return;
        }

        if (listing) {
            result.success(false)
            return;
        }

        listing = true;
        result.success(true)

        thread(start = true) {
            val rcs380 = Rcs380(device, usbManager);

            try {
                rcs380.open();

                while (listing) {
                    val tag = rcs380.senseTypeA();

                    if (tag != null && tag != previousTag) {
                        Log.d(TAG,"tag:$tag");

                        Handler(Looper.getMainLooper()).post {
                            if (listing) {
                                events?.success(tag);
                            }
                        }
                    }

                    previousTag = tag;
                    Thread.sleep(wait);
                }
            } catch (ex: Exception) {
                listing = false;
            } finally {
                rcs380.close();
            }
        }
    }

    fun disconnect(result: MethodChannel.Result) {
        listing = false
        result?.success(true)
    }

    fun dispose() {
        this.events = null;
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        this.events = events;
    }

    override fun onCancel(arguments: Any?) {
        this.events = null;
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "Method Call: ${call.method}")

        when (call.method) {
            "requestPermission" -> requestPermission(result)
            "connect" -> connect(result)
            "disconnect" -> disconnect(result)
            "hasPermission" -> hasPermission(result)
            "checkDevice" -> checkDevice(result)
            else -> result.notImplemented()
        }
    }

    private fun getDevice(): UsbDevice? {
        val device = usbManager.deviceList.values.filter { device ->
            device.vendorId == VENDOR_ID && device.productId == PRODUCT_ID
        }

        return device.firstOrNull()
    }
}
