//
//  YRWifiHelpTool.h
//  networkTest
//
//  Created by 　yangrui on 2017/8/24.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import <Foundation/Foundation.h>

// IP 相关
#define   kLocalDeviceIp        @"kLocalDeviceIp"       // 当前手机IP地址
#define   kBroadcastAddressIp   @"kBroadcastAddressIp"  // 当前手机IP地址
#define   kNetmaskIp            @"kNetmaskIp"           // 子网掩码IP地址
#define   kInterface            @"kInterface"           // 端口en0


// ssid 相关
#define   kBSSID  @"BSSID"
#define   kSSID   @"SSID"
#define   kSSIDDATA @"SSIDDATA"


@interface YRWifiHelper : NSObject


// 获取当前连接的 wifi 的IP 地址相关信息
+ (NSDictionary  *)fetchCurrentConnectedWifi_IdAddressInfo;

//获取当前 手机连接的WiFi 的SSID 相关信息
+ (NSDictionary *)fetchCurrentConnectedWifi_SSIDInfo;

@end



//@" 网络文化许可证吗"
