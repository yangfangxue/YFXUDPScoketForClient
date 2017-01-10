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
    
     udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //绑定端口号8000
    [udpSocket bindToPort:8000 error:nil];
    
    NSError *error = nil;
    //允许广播
    [udpSocket enableBroadcast:YES error:&error];
    //客户端本机IP地址172.20.10.3 加入广播
    [udpSocket joinMulticastGroup:@"172.20.10.3" error:nil];
    //开始准备接收数据
    [udpSocket beginReceiving:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //给服务端发送消息
    //172.20.10.1为服务端的IP地址
    //端口号要写成和客户端的端口号不一样 8099是服务端的端口号
    [udpSocket sendData:[@"我是客户端" dataUsingEncoding:NSUTF8StringEncoding] toHost:@"172.20.10.1" port:8099 withTimeout:-1 tag:10];
}
//UDP 回调函数
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    //接收客户端消息
    NSLog(@"ReceiveData = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
@end
