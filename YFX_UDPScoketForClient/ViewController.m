//
//  ViewController.m
//  YFX_UDPScoketForClient
//
//  Created by fangxue on 2017/1/10.
//  Copyright © 2017年 fangxue. All rights reserved.
//  
#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"
@interface ViewController ()<GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *udpSocket;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()] ;
    
    [udpSocket bindToPort:8000 error:nil];
    
    NSError *error = nil;
    
    [udpSocket enableBroadcast:YES error:&error];//允许广播 必须 否则后面无法发送组播和广播
    
    [udpSocket joinMulticastGroup:@"224.0.0.1" error:nil];
    
    [udpSocket beginReceiving:nil];//必须要  开始准备接收数据
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [udpSocket sendData:[@"1" dataUsingEncoding:NSUTF8StringEncoding] toHost:@"224.0.0.1" port:8099 withTimeout:-1 tag:0];
    
}
//UDP 回调函数
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    
    NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    
}
@end

