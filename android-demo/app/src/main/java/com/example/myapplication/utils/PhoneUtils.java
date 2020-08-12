package com.example.myapplication.utils;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;

public class PhoneUtils {

    private static NetworkInfo getNetworkInfo(Context context) {
        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        return cm.getActiveNetworkInfo();
    }

    /**
     * 判断网络类型：移动网络
     */
    public static boolean isMobile(Context context) {
        NetworkInfo networkInfo = getNetworkInfo(context);
        return null != networkInfo && networkInfo.getType() == ConnectivityManager.TYPE_MOBILE;
    }


    /**
     * 判断网络类型：Wi-Fi类型
     */
    public static boolean isWifi(Context context) {
        NetworkInfo networkInfo = getNetworkInfo(context);
        return null != networkInfo && networkInfo.getType() == ConnectivityManager.TYPE_WIFI;
    }

    /**
     * 判断网络是否连接
     */
    public static boolean isConnected(Context context) {
        NetworkInfo networkInfo = getNetworkInfo(context);
        return null != networkInfo && networkInfo.isConnected();
    }


    /**
     * 根据IP地址获取MAC地址
     */
    public static String getMacAddressFromIp() {
        String macAddr = null;
        try {
            InetAddress ip = getIpAddress();
            byte[] b = NetworkInterface.getByInetAddress(ip).getHardwareAddress();
            StringBuilder builder = new StringBuilder();
            for (int i = 0; i < b.length; i++) {
                if (i != 0) {
                    builder.append(':');
                }
                String str = Integer.toHexString(b[i] & 0xFF);
                builder.append(String.format("%2s", str).replace(" ","0"));

            }
            macAddr = builder.toString().toUpperCase();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return macAddr;
    }

    /**
     * 获取移动设备本地IP
     */
    public static InetAddress getIpAddress() {
        InetAddress ip = null;
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            while (interfaces.hasMoreElements()) {
                NetworkInterface ni =  interfaces.nextElement();
                Enumeration<InetAddress> ips = ni.getInetAddresses();
                while (ips.hasMoreElements()) {
                    ip = ips.nextElement();
                    if (!ip.isLoopbackAddress() && !ip.getHostAddress().contains(":"))
                        break;
                    else
                        ip = null;
                }
                if (ip != null) {
                    break;
                }
            }
        } catch (SocketException e) {
            e.printStackTrace();
        }
        return ip;
    }
}
