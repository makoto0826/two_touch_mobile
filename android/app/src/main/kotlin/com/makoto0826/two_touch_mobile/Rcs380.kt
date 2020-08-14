package com.makoto0826.two_touch_mobile

import android.hardware.usb.*
import android.util.Log
import java.util.*

internal const val TAG = "RCS380 Debug";

class Rcs380(
        private val device: UsbDevice,
        private val manager: UsbManager,
        private val isInDebugMode: Boolean = false
) {
    companion object {
        private const val COMMAND_HEADER = 0xd6;

        //CommandSize         2Byte
        //CommandSizeChecksum 1Byte
        //CommandHeader       1Byte
        //Command             1Byte
        //Checksum            1Byte
        //Footer              1Byte
        private const val SEND_DATA_PADDING_SIZE = 7

        private val HEADER =
                byteArrayOf(0x00, 0x00, 0xFF.toByte(), 0xFF.toByte(), 0xFF.toByte());

        private val ACK = byteArrayOf(0x00, 0x00, 0xFF.toByte(), 0x00, 0xFF.toByte(), 0x00);

        private fun isAck(data: ByteArray) = ACK.contentEquals(data);
    }

    private var deviceConnection: UsbDeviceConnection? = null

    private var usbInterface: UsbInterface? = null

    private var inEndpoint: UsbEndpoint? = null

    private var outEndpoint: UsbEndpoint? = null

    fun open() {
        usbInterface = device.getInterface(0)

        for (i in 0 until usbInterface!!.endpointCount) {
            val endPoint = usbInterface!!.getEndpoint(i);
            Log.d(TAG, "EndPoint:$endPoint")

            when (endPoint.direction) {
                UsbConstants.USB_DIR_OUT -> outEndpoint = endPoint
                UsbConstants.USB_DIR_IN -> inEndpoint = endPoint
            }
        }

        if (inEndpoint == null) {
            Log.d(TAG, "In EndPoint NOT FOUND")
            return;
        }

        if (outEndpoint == null) {
            Log.d("USB Debug", "Out EndPoint NOT FOUND")
            return;
        }

        deviceConnection = manager.openDevice(device)
        val index = device.configurationCount - 1

        if (!deviceConnection!!.setConfiguration(device.getConfiguration(index))) {
            Log.d(TAG, "Error setConfiguration")
            return
        }

        if (!deviceConnection!!.claimInterface(usbInterface, true)) {
            Log.d(TAG, "Error claimInterface")
            return
        }

        sendAck();
    }

    fun senseTypeA(): String? {
        sendCommand(0x2a, byteArrayOf(0x01))
        sendCommand(0x06, byteArrayOf(0x00))
        sendCommand(0x00, byteArrayOf(0x02, 0x03, 0x0f, 0x03))
        sendCommand(
                0x02,
                byteArrayOf(
                        0x00,
                        0x18,
                        0x01,
                        0x01,
                        0x02,
                        0x01,
                        0x03,
                        0x00,
                        0x04,
                        0x00,
                        0x05,
                        0x00,
                        0x06,
                        0x00,
                        0x07,
                        0x08,
                        0x08,
                        0x00,
                        0x09,
                        0x00,
                        0x0a,
                        0x00,
                        0x0b,
                        0x00,
                        0x0c,
                        0x00,
                        0x0e,
                        0x04,
                        0x0f,
                        0x00,
                        0x10,
                        0x00,
                        0x11,
                        0x00,
                        0x12,
                        0x00,
                        0x13,
                        0x06
                )
        )
        sendCommand(
                0x02,
                byteArrayOf(0x01, 0x00, 0x02, 0x00, 0x05, 0x01, 0x00, 0x06, 0x07, 0x07)
        )
        sendCommand(0x04, byteArrayOf(0x36, 0x01, 0x26))
        sendCommand(0x02, byteArrayOf(0x04, 0x01, 0x07, 0x08))
        sendCommand(0x02, byteArrayOf(0x01, 0x00, 0x02, 0x00))

        val receiveBuffer = sendCommand(0x04, byteArrayOf(0x36, 0x01, 0x93.toByte(), 0x20))
        return analyze(receiveBuffer)
    }

    fun close() {
        if (deviceConnection != null) {
            if (usbInterface != null) {
                deviceConnection!!.releaseInterface(usbInterface)
            }

            deviceConnection!!.close()
        }
    }

    private fun analyze(data: ByteArray): String? {
        if (data.size <= 18) {
            return null;
        }

        val result = data.drop(15).take(4);
        val sb = StringBuffer()

        for (byte in result) {
            val value = byte.toUByte()

            if (value < 16u) {
                sb.append("0");
            }

            sb.append(value.toString(16).toUpperCase(Locale.getDefault()))
        }

        return sb.toString();
    }

    private fun sendAck() {
        debugLog("ACK", ACK)
        deviceConnection!!.bulkTransfer(outEndpoint, ACK, 0, ACK.size, outEndpoint!!.interval)

        val receiveBuffer = ByteArray(inEndpoint!!.maxPacketSize)

        for (i in 1..5) {
            deviceConnection!!.bulkTransfer(inEndpoint, receiveBuffer, receiveBuffer.size, 10)
        }
    }

    private fun sendCommand(cmd: Byte, arguments: ByteArray): ByteArray {
        val sendData = ByteArray(HEADER.size + SEND_DATA_PADDING_SIZE + arguments.size)

        val size = arguments.size + 2// Command + CommandHeader
        val sizeLE1 = size and 0xFF;
        val sizeLE2 = (size ushr 8) and 0xFF;

        val total = arguments.sum() + cmd + COMMAND_HEADER;
        val checkSum = ((256 - total) % 256).toByte()

        HEADER.copyInto(sendData, 0);
        sendData[HEADER.size] =
                sizeLE1.toByte()
        sendData[HEADER.size + 1] = sizeLE2.toByte()
        sendData[HEADER.size + 2] =
                (256 - (sizeLE1 + sizeLE2) % 256).toByte()
        sendData[HEADER.size + 3] = COMMAND_HEADER.toByte()
        sendData[HEADER.size + 4] = cmd
        arguments.copyInto(sendData, HEADER.size + 5)
        sendData[HEADER.size + 5 + arguments.size] = checkSum;

        deviceConnection!!.bulkTransfer(
                outEndpoint,
                sendData,
                0,
                sendData.size,
                outEndpoint!!.interval
        )
        debugLog("Send:", sendData)

        var receiveBuffer = ByteArray(inEndpoint!!.maxPacketSize)
        var receiveCount =
                deviceConnection!!.bulkTransfer(
                        inEndpoint,
                        receiveBuffer,
                        receiveBuffer.size,
                        inEndpoint!!.interval
                )

        receiveBuffer = receiveBuffer.take(receiveCount).toByteArray()
        debugLog("Receive(ACK=${isAck(receiveBuffer)}):", receiveBuffer)

        receiveBuffer = ByteArray(inEndpoint!!.maxPacketSize)
        receiveCount =
                deviceConnection!!.bulkTransfer(
                        inEndpoint,
                        receiveBuffer,
                        receiveBuffer.size,
                        inEndpoint!!.interval
                )
        receiveBuffer = receiveBuffer.take(receiveCount).toByteArray()
        debugLog("Receive:", receiveBuffer)

        return receiveBuffer
    }

    private fun debugLog(message: String, data: ByteArray) {
        if (!isInDebugMode) {
            return;
        }

        val sb = StringBuffer();
        sb.append(" ")
                .append(message)
                .append(" ")

        for (byte in data.iterator()) {
            sb.append("0x")
                    .append(byte.toUByte().toString(16).toUpperCase(Locale.getDefault()).format(("%00")))
                    .append(" ")
        }

        Log.d(TAG, sb.toString());
    }

}


