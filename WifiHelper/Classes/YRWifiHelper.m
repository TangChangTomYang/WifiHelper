//
//  YRWifiHelpTool.m
//  networkTest
//
//  Created by 　yangrui on 2017/8/24.
//  Copyright © 2017年 　yangrui. All rights reserved.
//

#import "YRWifiHelper.h"

//1. 导入框架 文件
#import <NetworkExtension/NetworkExtension.h>

// 获取连接WiFi ip 地址需要用
#import <arpa/inet.h>
#import <netinet/in.h>
#import <ifaddrs.h>


// 获取当前 连接 WiFi ssid 要用
#import <SystemConfiguration/CaptiveNetwork.h>
@implementation YRWifiHelper



-(void)scanWifiInfo{
    

    NSMutableDictionary *optionDic = [NSMutableDictionary dictionary];
    
    NSString *name = @"MangoWifiHelper";
    optionDic[kNEHotspotHelperOptionDisplayName] = name; //设置热点帮助者的名字
    
    dispatch_queue_t queue = dispatch_queue_create(name.UTF8String, NULL);
    
   BOOL returnType = [NEHotspotHelper registerWithOptions:optionDic queue:queue handler:^(NEHotspotHelperCommand * _Nonnull cmd) {
        
        
        NEHotspotNetwork *hotspotNetwork = nil;
        
        if (cmd.commandType == kNEHotspotHelperCommandTypeEvaluate ||
            cmd.commandType == kNEHotspotHelperCommandTypeFilterScanList) {
            
            //遍历WiFi 列表,打印基本信息
            
            for(NEHotspotNetwork * network in cmd.networkList){
            
                
                NSString *wifiInfoStr = [NSString stringWithFormat:@"SSID: %@,mac: %@, 信号强度: %f,commandType:%ld",network.SSID,network.BSSID,network.signalStrength,(long)cmd.commandType];
                
                
                // 检测到指定的 wifi 可设定密码直接连接
                
                if([network.SSID isEqualToString:@"测试 wifi "]){
                
                    [network setConfidence:kNEHotspotHelperConfidenceHigh];
                    [network setPassword:@"123456"];
                    NEHotspotHelperResponse *cmdResponse = [cmd createResponse:kNEHotspotHelperResultSuccess];
                    
                    NSLog(@"cmd response: %@",cmdResponse);
                    
                    [cmdResponse setNetworkList:@[network]];
                    [cmdResponse setNetwork:network];
                    [cmdResponse deliver];
                
                }
            }
        }
        
        
    }];
    
    
    //注册成功, returnType 会返回 yes 否则返回 NO
    NSLog(@"注册 结果 %@", returnType == YES ? @"yes" : @"NO");

}



// 获取当前连接的 wifi 的IP 地址相关信息
+ (NSDictionary  *)fetchCurrentConnectedWifi_IdAddressInfo {
    
    
    NSDictionary *ipDic = nil;
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    int success = 0;
    success = getifaddrs(&interfaces);
    
    if (success == 0) {
        
        temp_addr = interfaces;
        
        while(temp_addr != NULL) {
            
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                
                
                // Check if interface is en0 which is the wifi connection on the iPhone
                
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    
                    
                    //广播地址
                    NSString *broadcastIpAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
                    // ip 地址
                    NSString *IpAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    //子网掩码地址
                    NSString *netmaskIp = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
                    //en0 端口地址
                    NSString *interfaceStr = [NSString stringWithUTF8String:temp_addr->ifa_name];
                    
                    
                    ipDic = @{kBroadcastAddressIp:broadcastIpAddress,
                              kLocalDeviceIp:IpAddress,
                              kNetmaskIp:netmaskIp,
                              kInterface:interfaceStr};
                    
                    
                    
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    
    return   ipDic ;
    
    
    
    
}


//获取当前 手机连接的WiFi 的SSID 相关信息
+ (NSDictionary *)fetchCurrentConnectedWifi_SSIDInfo {
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
    
    
    /**
     info
     {
     BSSID = "f0:b4:29:f6:cc:16";
     SSID = "Xiaomi_CC15";
     SSIDDATA = <5869616f 6d695f43 433135>;
     }
     
     */
}


@end
