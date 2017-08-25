//
//  YRViewController.m
//  WifiHelper
//
//  Created by TangchangTomYang on 08/25/2017.
//  Copyright (c) 2017 TangchangTomYang. All rights reserved.
//

#import "YRViewController.h"
#import "YRWifiHelper.h"

@interface YRViewController ()

@end

@implementation YRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 获取当前连接的 wifi 的IP 地址相关信息
    [YRWifiHelper fetchCurrentConnectedWifi_IdAddressInfo];
    
    //获取当前 手机连接的WiFi 的SSID 相关信息
    [YRWifiHelper fetchCurrentConnectedWifi_SSIDInfo];

}

@end
